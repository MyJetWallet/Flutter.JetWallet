import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_withdrawal_model.dart';
part 'iban_send_confirm_store.g.dart';

class IbanSendConfirmStore extends _IbanSendConfirmStoreBase
    with _$IbanSendConfirmStore {
  IbanSendConfirmStore() : super();

  static IbanSendConfirmStore of(BuildContext context) =>
      Provider.of<IbanSendConfirmStore>(context, listen: false);
}

abstract class _IbanSendConfirmStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  CurrencyModel eurCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'EUR',
  );

  void init(
    IbanPreviewWithdrawalModel data,
  ) {
    sAnalytics.orderSummarySendIBANScreenView(
      asset: eurCurrency.symbol,
      methodType: 'IBAN',
      sendAmount: data.amount.toString() ?? '0',
    );
  }

  @action
  Future<void> confirmIbanOut(
    IbanPreviewWithdrawalModel data,
    AddressBookContactModel contact,
  ) async {
    loader.startLoadingImmediately();

    final model = IbanWithdrawalModel(
      assetSymbol: 'EUR',
      amount: data.amount,
      lang: intl.localeName,
      contactId: contact.id,
      iban: data.iban,
      bic: data.bic,
    );

    final response = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getWalletModule()
        .postIbanWithdrawal(model);

    loader.finishLoadingImmediately();

    if (response.hasError) {
      sAnalytics.failedSendIBANScreenView(
        asset: 'EUR',
        methodType: 'IBAN',
        sendAmount: data.amount.toString(),
        failedReason: response.error?.cause ?? '',
      );

      await showFailureScreen(response.error?.cause ?? '');
    } else {
      sAnalytics.successSendIBANScreenView(
        asset: 'EUR',
        methodType: 'IBAN',
        sendAmount: data.amount.toString(),
      );

      await showSuccessScreen(data);
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
  Future<void> showSuccessScreen(IbanPreviewWithdrawalModel data) {
    return sRouter
        .push(
          SuccessScreenRouter(
            primaryText: intl.send_globally_success,
            secondaryText:
                '${intl.send_globally_success_secondary} ${volumeFormat(
              prefix: eurCurrency.prefixSymbol,
              decimal: data.sendAmount ?? Decimal.zero,
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
                PortfolioRouter(),
              ],
            ),
          ]),
        );
  }
}
