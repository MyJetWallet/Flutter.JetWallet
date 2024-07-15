import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
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
    sAnalytics.earnDepositOrderSummaryScreenView(
      assetName: offer.assetId,
      earnAPYrate: offer.apyRate?.toString() ?? Decimal.zero.toString(),
      earnDepositAmount: amount.toString(),
      earnPlanName: offer.description ?? '',
      earnWithdrawalType: offer.withdrawType.name,
    );
    requestId = DateTime.now().microsecondsSinceEpoch.toString();

    final formatService = getIt.get<FormatService>();
    baseAmount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: offer.assetId,
      fromCurrencyAmmount: amount,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );

    _isChecked();
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
        findInHideTerminalList: true,
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
    _setIsChecked(isTermsAndConditionsChecked);
  }

  @action
  Future<void> _isChecked() async {
    try {
      final storage = sLocalStorageService;

      final status = await storage.getValue(earnTermsAndConditionsWasChecked);
      if (status != null && status == 'true') {
        isTermsAndConditionsChecked = true;
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'EarnConfirmationStore',
            message: e.toString(),
          );
    }
  }

  @action
  Future<void> _setIsChecked(bool value) async {
    try {
      final storage = sLocalStorageService;

      await storage.setString(
        earnTermsAndConditionsWasChecked,
        value.toString(),
      );
      isTermsAndConditionsChecked = value;
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'EarnConfirmationStore',
            message: e.toString(),
          );
    }
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
    sAnalytics.successEarnDepositScreenView(
      assetName: offer.assetId,
      earnAPYrate: offer.apyRate?.toString() ?? Decimal.zero.toString(),
      earnDepositAmount: selectedAmount.toString(),
      earnPlanName: offer.description ?? '',
      earnWithdrawalType: offer.withdrawType.name,
    );
    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.earn_transfer_of(
          volumeFormat(
            decimal: selectedAmount,
            symbol: selectedCurrency.symbol,
            accuracy: selectedCurrency.accuracy,
          ),
        ),
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

    sAnalytics.failedEarnDepositScreenView(
      assetName: offer.assetId,
      earnAPYrate: offer.apyRate?.toString() ?? Decimal.zero.toString(),
      earnDepositAmount: selectedAmount.toString(),
      earnPlanName: offer.description ?? '',
      earnWithdrawalType: offer.withdrawType.name,
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
}
