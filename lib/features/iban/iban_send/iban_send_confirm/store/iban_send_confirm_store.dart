import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_response.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_request.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/execute_crypto_sell_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_response_model.dart';
import 'package:uuid/uuid.dart';

part 'iban_send_confirm_store.g.dart';

class IbanSendConfirmStore extends _IbanSendConfirmStoreBase with _$IbanSendConfirmStore {
  IbanSendConfirmStore() : super();

  static IbanSendConfirmStore of(BuildContext context) => Provider.of<IbanSendConfirmStore>(context, listen: false);
}

abstract class _IbanSendConfirmStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  var requestId = '';

  @observable
  bool deviceBindingRequired = false;

  CurrencyModel eurCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'EUR',
  );

  void init(
    BankingWithdrawalPreviewResponse? data,
    GetCryptoSellResponseModel? cryptoSell,
  ) {
    if (data != null) {
      deviceBindingRequired = data.deviceBindingRequired ?? false;
    } else {

    }

    requestId = const Uuid().v1();
  }

  @action
  Future<void> confirmIbanOut(
    BankingWithdrawalPreviewModel previewRequest,
    BankingWithdrawalPreviewResponse data,
    AddressBookContactModel contact,
    String pin,
    SimpleBankingAccount account,
    bool isCJ,
  ) async {
    try {
      if (deviceBindingRequired) {
        var continueBuying = false;

        final formatedAmaunt = (data.amount ?? Decimal.fromInt(200)).toFormatCount(
          symbol: eurCurrency.symbol,
          accuracy: eurCurrency.accuracy,
        );
        await Future.delayed(const Duration(milliseconds: 500));
        await sShowAlertPopup(
          sRouter.navigatorKey.currentContext!,
          primaryText: '',
          secondaryText:
              '${intl.binding_phone_dialog_first_part_2} $formatedAmaunt ${intl.binding_phone_dialog_second_part_2}',
          primaryButtonName: intl.binding_phone_dialog_confirm,
          secondaryButtonName: intl.binding_phone_dialog_cancel,
          image: Image.asset(
            infoLightAsset,
            width: 80,
            height: 80,
            package: 'simple_kit',
          ),
          onPrimaryButtonTap: () {
            continueBuying = true;
            sRouter.maybePop();
          },
          onSecondaryButtonTap: () {
            continueBuying = false;
            sRouter.maybePop();
          },
        );

        if (!continueBuying) return;

        final phoneNumber = countryCodeByUserRegister();
        var isVerifaierd = false;
        await sRouter.push(
          PhoneVerificationRouter(
            args: PhoneVerificationArgs(
              isDeviceBinding: true,
              phoneNumber: sUserInfo.phone,
              activeDialCode: phoneNumber,
              onVerified: () {
                isVerifaierd = true;
                sRouter.maybePop();
              },
            ),
          ),
        );
        if (!isVerifaierd) return;
      }

      loader.startLoadingImmediately();

      final model = BankingWithdrawalRequest(
        pin: pin,
        accountId: previewRequest.accountId,
        requestId: requestId,
        toIbanAddress: previewRequest.toIbanAddress,
        contactId: previewRequest.contactId,
        assetSymbol: 'EUR',
        amount: data.amount,
        description: previewRequest.description,
        beneficiaryName: previewRequest.beneficiaryName,
        beneficiaryAddress: previewRequest.beneficiaryAddress,
        beneficiaryBankCode: previewRequest.beneficiaryBankCode,
        beneficiaryCountry: previewRequest.beneficiaryCountry,
        expressPayment: previewRequest.expressPayment,
      );

      final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postBankingWithdrawal(model);

      loader.finishLoadingImmediately();

      if (response.hasError) {
        sAnalytics.eurWithdrawFailed(
          isCJ: isCJ,
          accountIban: account.iban ?? '',
          accountLabel: account.label ?? '',
          eurAccType: contact.iban ?? '',
          eurAccLabel: contact.name ?? '',
          enteredAmount: data.amount.toString(),
        );

        await showFailureScreen(response.error?.cause ?? '');
      } else {
        sAnalytics.eurWithdrawSuccessWithdrawEndSV(
          isCJ: isCJ,
          accountIban: account.iban ?? '',
          accountLabel: account.label ?? '',
          eurAccType: contact.iban ?? '',
          eurAccLabel: contact.name ?? '',
          enteredAmount: data.amount.toString(),
        );

        await showSuccessScreen(data.sendAmount);
      }
    } on ServerRejectException catch (error) {
      sAnalytics.eurWithdrawFailed(
        isCJ: isCJ,
        accountIban: account.iban ?? '',
        accountLabel: account.label ?? '',
        eurAccType: contact.iban ?? '',
        eurAccLabel: contact.name ?? '',
        enteredAmount: data.amount.toString(),
      );
      unawaited(showFailureScreen(error.cause));
    } catch (error) {
      sAnalytics.eurWithdrawFailed(
        isCJ: isCJ,
        accountIban: account.iban ?? '',
        accountLabel: account.label ?? '',
        eurAccType: contact.iban ?? '',
        eurAccLabel: contact.name ?? '',
        enteredAmount: data.amount.toString(),
      );
      unawaited(showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> confirmCryptoIbanOut(
      BankingWithdrawalPreviewModel previewRequest,
      GetCryptoSellResponseModel data,
      AddressBookContactModel contact,
      String pin,
      SimpleBankingAccount account,
      bool isCJ,
      ) async {
    try {
      loader.startLoadingImmediately();

      final model = ExecuteCryptoSellRequestModel(
        paymentId: data.id,
      );

      final response = await sNetwork.getWalletModule().postSellExecute(
        model,
      );

      loader.finishLoadingImmediately();

      if (response.hasError) {
        await showFailureScreen(response.error?.cause ?? '');
      } else {
        await showSuccessScreen(response.data!.buyAmount);
      }
    } on ServerRejectException catch (error) {
      unawaited(showFailureScreen(error.cause));
    } catch (error) {
      unawaited(showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> showFailureScreen(String error) {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error,
      ),
    );
  }

  @action
  Future<void> showSuccessScreen(Decimal? sendAmount) {
    return sRouter
        .push(
      SuccessScreenRouter(
        primaryText: intl.send_globally_success,
        secondaryText: '${intl.send_globally_success_secondary} ${(sendAmount ?? Decimal.zero).toFormatCount(
          accuracy: eurCurrency.accuracy,
          symbol: eurCurrency.symbol,
        )}'
            '\n${intl.send_globally_success_secondary_2}',
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
}
