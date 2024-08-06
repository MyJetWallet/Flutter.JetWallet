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
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_deposit_position/earn_deposit_position_request_model.dart';

part 'earn_top_up_order_summary_store.g.dart';

class EarnTopUpOrderSummaryStore extends _EarnTopUpOrderSummaryStoreBase with _$EarnTopUpOrderSummaryStore {
  EarnTopUpOrderSummaryStore({
    required super.earnPosition,
    required super.amount,
  }) : super();

  static EarnTopUpOrderSummaryStore of(BuildContext context) =>
      Provider.of<EarnTopUpOrderSummaryStore>(context, listen: false);
}

abstract class _EarnTopUpOrderSummaryStoreBase with Store {
  _EarnTopUpOrderSummaryStoreBase({
    required this.earnPosition,
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

    _isChecked();
  }

  final EarnPositionClientModel earnPosition;

  final Decimal amount;

  @computed
  EarnOfferClientModel get offer => earnPosition.offers.first;

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

      final model = EarnDepositPositionRequestModel(
        requestId: requestId,
        positionId: earnPosition.id,
        assetId: earnPosition.assetId,
        amount: amount,
      );

      final DC<ServerRejectException, dynamic> resp = await sNetwork.getWalletModule().postEarnDepositPosition(model);

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/earn_top_up_order_summary') {
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
      assetName: earnPosition.offers.first.assetId,
      earnAPYrate: earnPosition.offers.first.apyRate.toString(),
      earnDepositAmount: amount.toString(),
      earnPlanName: earnPosition.offers.first.name ?? '',
      earnWithdrawalType: earnPosition.offers.first.withdrawType.name,
    );

    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.earn_transfer_of(
          amount.toFormatCount(
            symbol: selectedCurrency.symbol,
            accuracy: selectedCurrency.accuracy,
          ),
        ),
      ),
    )
        .then((value) {
      sRouter.replaceAll([
        const HomeRouter(
          children: [],
        ),
      ]);
    });
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    if (sRouter.currentPath != '/earn_top_up_order_summary') {
      return;
    }

    sAnalytics.failedEarnDepositScreenView(
      assetName: earnPosition.offers.first.assetId,
      earnAPYrate: earnPosition.offers.first.apyRate.toString(),
      earnDepositAmount: amount.toString(),
      earnPlanName: earnPosition.offers.first.name ?? '',
      earnWithdrawalType: earnPosition.offers.first.withdrawType.name,
    );

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.failed,
          secondaryText: intl.something_went_wrong_try_again,
        ),
      ),
    );
  }
}
