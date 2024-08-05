import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/utils/device_binding_required_flow/show_device_binding_required_flow.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_request_model.dart';

part 'transfer_confirmation_store.g.dart';

class TransferConfirmationStore extends _TransferConfirmationStoreBase with _$TransferConfirmationStore {
  TransferConfirmationStore() : super();

  static TransferConfirmationStore of(BuildContext context) =>
      Provider.of<TransferConfirmationStore>(context, listen: false);
}

abstract class _TransferConfirmationStoreBase with Store {
  final eurCurrency = nonIndicesWithBalanceFrom(
    sSignalRModules.currenciesList,
  ).where((element) => element.symbol == 'EUR').first;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isDataLoaded = false;

  @observable
  bool showProcessing = true;

  @observable
  String fromLable = '';
  @observable
  Decimal fromAmount = Decimal.zero;
  @observable
  String fromAccountId = '';
  @observable
  CredentialsType toType = CredentialsType.clearjunctionAccount;

  @observable
  String toLable = '';
  @observable
  Decimal toAmount = Decimal.zero;
  @observable
  String toAccountId = '';
  @observable
  CredentialsType fromType = CredentialsType.clearjunctionAccount;

  @observable
  String benificiary = '';
  @observable
  String reference = '';
  @observable
  String receiverPhoneNumber = '';

  @observable
  String paymentFee = '';
  @observable
  String processingFee = '';

  String requestId = '';

  bool deviceBindingRequired = false;
  bool smsVerificationRequired = false;

  String operationId = '';

  @action
  void init({
    required Decimal amount,
    CardDataModel? fromCard,
    CardDataModel? toCard,
    SimpleBankingAccount? fromAccount,
    SimpleBankingAccount? toAccount,
  }) {
    requestId = DateTime.now().microsecondsSinceEpoch.toString();

    fromLable = fromAccount?.label ?? fromCard?.label ?? '';
    fromAmount = amount;
    fromAccountId = fromAccount?.accountId ?? fromCard?.cardId ?? '';
    if (fromAccount != null && fromAccount.isClearjuctionAccount) {
      fromType = CredentialsType.clearjunctionAccount;
    } else if (fromAccount != null && !fromAccount.isClearjuctionAccount) {
      fromType = CredentialsType.unlimitAccount;
    } else {
      fromType = CredentialsType.unlimitCard;
    }

    toLable = toAccount?.label ?? toCard?.label ?? '';
    toAccountId = toAccount?.accountId ?? toCard?.cardId ?? '';
    if (toAccount != null && toAccount.isClearjuctionAccount) {
      toType = CredentialsType.clearjunctionAccount;
    } else if (toAccount != null && !toAccount.isClearjuctionAccount) {
      toType = CredentialsType.unlimitAccount;
    } else {
      toType = CredentialsType.unlimitCard;
    }

    sAnalytics.transferOrderSummaryScreenView(
      transferFrom: fromType.analyticsValue,
      transferTo: toType.analyticsValue,
      enteredAmount: fromAmount.toString(),
    );

    _createPayment();
  }

  Future<void> _createPayment() async {
    try {
      showProcessing = false;
      loader.startLoadingImmediately();
      final model = AccountTransferPreviewRequestModel(
        requestId: requestId,
        fromAssetSymbol: eurCurrency.symbol,
        fromAmount: fromAmount,
        fromAccount: CredentialsModel(
          accountId: fromAccountId,
          type: fromType,
        ),
        toAccount: CredentialsModel(
          accountId: toAccountId,
          type: toType,
        ),
      );

      final response = await sNetwork.getWalletModule().postTransferPreview(model);

      response.pick(
        onData: (data) {
          fromAmount = data.fromAmount;
          toAmount = data.toAmount;
          paymentFee = (data.paymentFeeAmount ?? Decimal.zero).toFormatCount(
            symbol: eurCurrency.symbol,
            accuracy: eurCurrency.accuracy,
          );
          deviceBindingRequired = data.deviceBindingRequired;
          smsVerificationRequired = data.smsVerificationRequired;
          processingFee = (data.simpleFeeAmount ?? Decimal.zero).toFormatCount(
            symbol: eurCurrency.symbol,
            accuracy: eurCurrency.accuracy,
          );
          benificiary = data.beneficiaryFullName ?? '';
          reference = data.reference ?? '';
          operationId = data.operationId;
          receiverPhoneNumber = data.receiverPhoneNumber ?? '';
        },
        onError: (error) {
          loader.finishLoadingImmediately();
          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.something_went_wrong));
    } finally {
      loader.finishLoadingImmediately();

      isDataLoaded = true;

      showProcessing = !smsVerificationRequired;
    }
  }

  @action
  Future<void> confirmTransfer() async {
    try {
      sAnalytics.tapAnTheButtonConfirmOnTransferOrderSummary(
        transferFrom: fromType.analyticsValue,
        transferTo: toType.analyticsValue,
        enteredAmount: fromAmount.toString(),
      );

      if (deviceBindingRequired) {
        var isVerifaierd = false;

        await showDeviceBindingRequiredFlow(
          onConfirmed: () {
            isVerifaierd = true;
          },
        );

        if (!isVerifaierd) return;
      }

      var isConfirmed = false;

      if (smsVerificationRequired) {
        sAnalytics.confirmTransferViaSMSScreenView(
          transferFrom: fromType.analyticsValue,
          transferTo: toType.analyticsValue,
          amount: fromAmount.toString(),
        );

        await showSMSVerificationPopUp(
          onConfirmed: () {
            isConfirmed = true;
            sAnalytics.tapOnTheButtonContinueOnConfirmViaSMSScreen(
              transferFrom: fromType.analyticsValue,
              transferTo: toType.analyticsValue,
              amount: fromAmount.toString(),
            );
          },
          onCanceled: () {
            requestId = DateTime.now().microsecondsSinceEpoch.toString();
            sAnalytics.tapOnTheButtonCancelOnConfirmViaSMSScreen(
              transferFrom: fromType.analyticsValue,
              transferTo: toType.analyticsValue,
              amount: fromAmount.toString(),
            );
          },
        );
        if (!isConfirmed) return;
      }

      loader.startLoadingImmediately();

      final model = AccountTransferRequestModel(
        requestId: requestId,
        fromAssetSymbol: eurCurrency.symbol,
        fromAmount: fromAmount,
        fromAccount: CredentialsModel(
          accountId: fromAccountId,
          type: fromType,
        ),
        toAccount: CredentialsModel(
          accountId: toAccountId,
          type: toType,
        ),
        operationId: operationId,
      );

      final response = await sNetwork.getWalletModule().postTransferRequest(model);

      response.pick(
        onData: (data) async {
          operationId = data.operationId;
          var isVerifaierd = false;
          if (data.smsVerificationRequired) {
            await showSMSVerificationScreen(
              onConfirmed: () {
                isVerifaierd = true;
              },
            );
            requestId = DateTime.now().microsecondsSinceEpoch.toString();
            if (!isVerifaierd) return;
          }

          await _showSuccessScreen();
        },
        onError: (error) {
          loader.finishLoading();
          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      loader.finishLoading();

      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      loader.finishLoading();

      unawaited(_showFailureScreen(intl.something_went_wrong));
    } finally {
      loader.finishLoading();

      isDataLoaded = true;
    }
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoading();

    if (sRouter.currentPath != '/transfer_confirmation') {
      return;
    }

    sAnalytics.failedTransferEndScreenView(
      transferFrom: fromType.analyticsValue,
      transferTo: toType.analyticsValue,
      enteredAmount: fromAmount.toString(),
    );

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
        ),
      ),
    );
  }

  @action
  Future<void> _showSuccessScreen() {
    sAnalytics.successTransferEndScreenView(
      transferFrom: fromType.analyticsValue,
      transferTo: toType.analyticsValue,
      enteredAmount: fromAmount.toString(),
    );

    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.transfet_success_text(
          fromAmount.toFormatCount(
            accuracy: eurCurrency.accuracy,
            symbol: eurCurrency.symbol,
          ),
        ),
      ),
    )
        .then((value) {
      sRouter.replaceAll([
        const HomeRouter(
          children: [
            MyWalletsRouter(),
          ],
        ),
      ]);

      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
  }

  Future<void> showSMSVerificationPopUp({
    void Function()? onConfirmed,
    void Function()? onCanceled,
  }) async {
    final userPhoneNumber = receiverPhoneNumber.length > 5
        ? receiverPhoneNumber.substring(receiverPhoneNumber.length - 4)
        : receiverPhoneNumber;

    await sShowAlertPopup(
      sRouter.navigatorKey.currentContext!,
      primaryText: intl.transfer_confirm_via_sms,
      secondaryText: intl.transfer_we_sent(userPhoneNumber),
      primaryButtonName: intl.showSmsAuthWarning_continue,
      secondaryButtonName: intl.binding_phone_dialog_cancel,
      barrierDismissible: false,
      image: Image.asset(
        messageAsset,
        width: 80,
        height: 80,
        package: 'simple_kit',
      ),
      onPrimaryButtonTap: () {
        onConfirmed?.call();
        sRouter.maybePop();
      },
      onSecondaryButtonTap: () {
        sRouter.maybePop();
        onCanceled?.call();
      },
    );
  }

  Future<void> showSMSVerificationScreen({
    void Function()? onConfirmed,
  }) async {
    sAnalytics.confirmCodeTransferViaSMSScreenView(
      transferFrom: fromType.analyticsValue,
      transferTo: toType.analyticsValue,
      amount: fromAmount.toString(),
    );

    final phoneNumber = countryCodeByUserRegister();
    await sRouter.push(
      PhoneVerificationRouter(
        args: PhoneVerificationArgs(
          phoneNumber: sUserInfo.phone,
          activeDialCode: phoneNumber,
          isUnlimitTransferConfirm: true,
          transactionId: operationId,
          onVerified: () {
            sRouter.maybePop();
            onConfirmed?.call();
          },
          onBackTap: () {
            sAnalytics.tapOnTheButtonBackOnConfirmCodeViaSMSScreen(
              transferFrom: fromType.analyticsValue,
              transferTo: toType.analyticsValue,
              amount: fromAmount.toString(),
            );
          },
          onLoaderStart: () {
            sAnalytics.loaderWithSMSCodeOnConfirmTransferScreenView(
              transferFrom: fromType.analyticsValue,
              transferTo: toType.analyticsValue,
              amount: fromAmount.toString(),
            );
          },
        ),
      ),
    );
  }
}
