import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/device_binding_required_flow/show_device_binding_required_flow.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
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
  String paymentFee = '';
  @observable
  String processingFee = '';

  String requestId = '';

  bool deviceBindingRequired = false;

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

    _createPayment();
  }

  Future<void> _createPayment() async {
    try {
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
          paymentFee = volumeFormat(
            symbol: eurCurrency.symbol,
            accuracy: eurCurrency.accuracy,
            decimal: data.paymentFeeAmount ?? Decimal.zero,
          );
          deviceBindingRequired = data.deviceBindingRequired;
          processingFee = volumeFormat(
            symbol: eurCurrency.symbol,
            accuracy: eurCurrency.accuracy,
            decimal: data.simpleFeeAmount ?? Decimal.zero,
          );
          benificiary = data.beneficiaryFullName ?? '';
          reference = data.reference ?? '';
          operationId = data.operationId;
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
      loader.finishLoading();

      isDataLoaded = true;
    }
  }

  @action
  Future<void> confirmTransfer() async {
    try {
      if (deviceBindingRequired) {
        var isVerifaierd = false;

        await showDeviceBindingRequiredFlow(
          onConfirmed: () {
            isVerifaierd = true;
          },
        );

        if (!isVerifaierd) return;
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
        onData: (data) {
          _showSuccessScreen();
        },
        onError: (error) {
          loader.finishLoadingImmediately();
          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      loader.finishLoadingImmediately();

      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      loader.finishLoadingImmediately();

      unawaited(_showFailureScreen(intl.something_went_wrong));
    } finally {
      loader.finishLoadingImmediately();

      isDataLoaded = true;
    }
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoading();

    if (sRouter.currentPath != '/transfer_confirmation') {
      return;
    }

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
          primaryButtonName: intl.previewBuyWithAsset_close,
          onPrimaryButtonTap: () {
            navigateToRouter();
          },
        ),
      ),
    );
  }

  @action
  Future<void> _showSuccessScreen() {
    return sRouter
        .push(
          SuccessScreenRouter(
            secondaryText: intl.transfet_success_text(
              volumeFormat(
                decimal: fromAmount,
                accuracy: eurCurrency.accuracy,
                symbol: eurCurrency.symbol,
              ),
            ),
            buttonText: intl.previewBuyWithUmlimint_saveCard,
            showProgressBar: true,
            showCloseButton: true,
            onCloseButton: () {
              sRouter.replaceAll([
                const HomeRouter(
                  children: [
                    MyWalletsRouter(),
                  ],
                ),
              ]);
            },
          ),
        )
        .then(
          (value) => sRouter.replaceAll([
            const HomeRouter(
              children: [
                MyWalletsRouter(),
              ],
            ),
          ]),
        );
  }
}
