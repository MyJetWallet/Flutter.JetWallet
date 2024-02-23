import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_request/earn_offer_request_model.dart';

part 'earn_offer_order_summary_store.g.dart';

class OfferOrderSummaryStore extends _OfferOrderSummaryStoreBase with _$OfferOrderSummaryStore {
  OfferOrderSummaryStore({
    required super.offer,
    required super.amount,
  }) : super();

  static OfferOrderSummaryStore of(BuildContext context) => Provider.of<OfferOrderSummaryStore>(context, listen: false);
}

abstract class _OfferOrderSummaryStoreBase with Store {
  _OfferOrderSummaryStoreBase({
    required this.offer,
    required this.amount,
  }) {
    requestId = DateTime.now().microsecondsSinceEpoch.toString();

    final formatService = getIt.get<FormatService>();
    baseAmount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: offer.assetId,
      fromCurrencyAmmount: amount,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );
  }

  final EarnOfferClientModel offer;
  final Decimal amount;

  @observable
  Decimal baseAmount = Decimal.zero;

  @observable
  bool isTermsAndConditionsChecked = false;

  @computed
  Decimal get selectedAmount => amount;

  @computed
  Decimal get baseCryptoAmount {
    final formatService = getIt.get<FormatService>();

    return formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: offer.assetId,
      fromCurrencyAmmount: currency.assetBalance,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );
  }

  @computed
  CurrencyModel get currency => getIt.get<FormatService>().findCurrency(
        assetSymbol: offer.assetId,
      );

  @computed
  CurrencyModel get eurCurrency => getIt.get<FormatService>().findCurrency(
        assetSymbol: fiatSymbol,
      );

  @computed
  CurrencyModel get selectedCurrency => getIt.get<FormatService>().findCurrency(
        assetSymbol: offer.assetId,
      );

  @computed
  String get fiatSymbol {
    final baseCurrency = sSignalRModules.baseCurrency;
    return baseCurrency.symbol;
  }

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool showProcessing = false;

  @observable
  bool isWaitingSkipped = false;

  String requestId = '';

  @action
  void toggleCheckbox() {
    isTermsAndConditionsChecked = !isTermsAndConditionsChecked;
  }

  @action
  Future<void> confirm() async {
    try {
      showProcessing = true;

      loader.startLoadingImmediately();

      late final DC<ServerRejectException, dynamic> resp;

      final model = EarnOfferRequestModel(
        requestId: requestId,
        assetId: currency.symbol,
        offerId: offer.id,
        amount: selectedAmount,
      );

      resp = await sNetwork.getWalletModule().postEarnOfferCreatePosition(model);

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.errorCode ?? '');

        return;
      }

      if (sRouter.currentPath != '/offer_order_summary') {
        return;
      }

      if (isWaitingSkipped) {
        return;
      }
      unawaited(_showSuccessScreen(false));

      skippedWaiting();
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  void skippedWaiting() {
    isWaitingSkipped = true;
  }

  @action
  Future<void> _showSuccessScreen(bool isGoogle) {
    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.earn_withdraw_successfully,
        buttonText: intl.previewBuyWithUmlimint_saveCard,
        showProgressBar: true,
      ),
    )
        .then((value) {
      sRouter.replaceAll([
        const HomeRouter(),
      ]);
    });
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    if (sRouter.currentPath != '/offer_order_summary') {
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
}
