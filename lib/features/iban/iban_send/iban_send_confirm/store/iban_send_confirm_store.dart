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
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_response.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_request.dart';
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
    BankingWithdrawalPreviewResponse data,
  ) {
    deviceBindingRequired = data.deviceBindingRequired ?? false;

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
    if (deviceBindingRequired) {
      var continueBuying = false;

      final formatedAmaunt = volumeFormat(
        symbol: eurCurrency.symbol,
        accuracy: eurCurrency.accuracy,
        decimal: data.amount ?? Decimal.fromInt(200),
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
          sRouter.pop();
        },
        onSecondaryButtonTap: () {
          continueBuying = false;
          sRouter.pop();
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
              sRouter.pop();
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
        eurAccountType: isCJ ? 'CJ' : 'Unlimit',
        accountIban: account.iban ?? '',
        accountLabel: account.label ?? '',
        eurAccType: contact.iban ?? '',
        eurAccLabel: contact.name ?? '',
        enteredAmount: data.amount.toString(),
      );

      await showFailureScreen(response.error?.cause ?? '');
    } else {

      sAnalytics.eurWithdrawSuccessWithdrawEndSV(
        eurAccountType: isCJ ? 'CJ' : 'Unlimit',
        accountIban: account.iban ?? '',
        accountLabel: account.label ?? '',
        eurAccType: contact.iban ?? '',
        eurAccLabel: contact.name ?? '',
        enteredAmount: data.amount.toString(),
      );

      await showSuccessScreen(data.sendAmount);
    }
  }

  @action
  Future<void> showFailureScreen(String error) {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error,
        primaryButtonName: intl.send_globally_fail_info,
        onPrimaryButtonTap: () {
          navigateToRouter();
        },
      ),
    );
  }

  @action
  Future<void> showSuccessScreen(Decimal? sendAmount) {
    return sRouter
        .push(
          SuccessScreenRouter(
            primaryText: intl.send_globally_success,
            secondaryText: '${intl.send_globally_success_secondary} ${volumeFormat(
              decimal: sendAmount ?? Decimal.zero,
              accuracy: eurCurrency.accuracy,
              symbol: eurCurrency.symbol,
            )}'
                '\n${intl.send_globally_success_secondary_2}',
            showProgressBar: true,
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
