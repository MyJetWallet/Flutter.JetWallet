import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/high_yield_buy/model/preview_high_yield_buy_input.dart';
import 'package:jetwallet/features/high_yield_buy/model/preview_high_yield_buy_union.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_deposit/earn_offer_deposit_request_model.dart';

part 'preview_high_yield_buy_store.g.dart';

class PreviewHighYieldBuyStore extends _PreviewHighYieldBuyStoreBase
    with _$PreviewHighYieldBuyStore {
  PreviewHighYieldBuyStore(PreviewHighYieldBuyInput input) : super(input);

  static _PreviewHighYieldBuyStoreBase of(BuildContext context) =>
      Provider.of<PreviewHighYieldBuyStore>(context, listen: false);
}

abstract class _PreviewHighYieldBuyStoreBase with Store {
  _PreviewHighYieldBuyStoreBase(this.input) {
    _updateFrom(input);
    calculateEarnOfferApy();
  }

  final PreviewHighYieldBuyInput input;

  static final _logger = Logger('PreviewHighYieldBuyStore');

  @observable
  String? operationId;

  @observable
  Decimal? price;

  @observable
  String? fromAssetSymbol;

  @observable
  String? toAssetSymbol;

  @observable
  Decimal? fromAssetAmount;

  @observable
  Decimal? toAssetAmount;

  @observable
  Decimal? feePercent;

  // Will be initialzied on initState of the parent widget
  @observable
  AnimationController? timerAnimation;

  // [true] when requestQuote() takes too long
  @observable
  bool connectingToServer = false;

  @observable
  PreviewHighYieldBuyUnion union =
      const PreviewHighYieldBuyUnion.quoteLoading();

  @observable
  int timer = 0;

  @observable
  Decimal? apy;

  @observable
  Decimal? expectedYearlyProfit;

  @observable
  Decimal? expectedYearlyProfitBase;

  @observable
  Decimal? expectedDailyProfit;

  @observable
  Decimal? expectedDailyProfitBase;

  void _updateFrom(PreviewHighYieldBuyInput input) {
    fromAssetAmount = Decimal.parse(input.amount);
    fromAssetSymbol = input.fromCurrency.symbol;
    toAssetSymbol = input.toCurrency.symbol;
  }

  Future<void> calculateEarnOfferApy() async {
    _logger.log(notifier, 'calculateEarnOfferApy');

    union = const PreviewHighYieldBuyUnion.quoteLoading();

    final model = CalculateEarnOfferApyRequestModel(
      offerId: input.earnOffer.offerId,
      assetSymbol: 'USD',
      amount: Decimal.parse(input.amount),
    );

    try {
      final response =
          await sNetwork.getWalletModule().postCalculateEarnOfferApy(model);

      response.pick(
        onData: (data) {
          apy = data.apy;
          expectedYearlyProfit = data.expectedYearlyProfit;
          expectedYearlyProfitBase = data.expectedYearlyProfitBaseAsset;
          expectedDailyProfit = data.expectedDailyProfit;
          expectedDailyProfitBase = data.expectedDailyProfitBaseAsset;
          union = const PreviewHighYieldBuyUnion.quoteSuccess();
        },
        onError: (error) {
          _logger.log(stateFlow, 'calculateEarnOfferApy', error.cause);

          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', error.cause);

      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', error);

      sNotification.showError(
        error.toString(),
        id: 1,
      );
    }
  }

  Future<void> earnOfferDeposit(String offerId) async {
    _logger.log(notifier, 'earnOfferDeposit');

    union = const PreviewHighYieldBuyUnion.quoteLoading();

    try {
      final model = EarnOfferDepositRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        offerId: offerId,
        offerAssetSymbol: fromAssetSymbol ?? '',
        baseAssetSymbol: sSignalRModules.baseCurrency.symbol,
        amount: fromAssetAmount ?? Decimal.zero,
      );

      final _ = await sNetwork.getWalletModule().postEarnOfferDeposit(model);

      await _showSuccessScreen();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'earnOfferDeposit', error.cause);

      await _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'earnOfferDeposit', error);

      await _showFailureScreen(
        ServerRejectException(intl.preview_earn_buy_error),
      );
    }
  }

  Future<void> _showSuccessScreen() {
    return sRouter.push(
      SuccessScreenRouter(
        secondaryText: input.topUp
            ? intl.success_earn_top_up_message
            : intl.success_earn_buy_message,
      ),
    );
  }

  Future<void> _showFailureScreen(ServerRejectException error) {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.failure_earn_buy_message,
        secondaryText: error.cause,
        primaryButtonName: intl.failure_earn_buy_close,
        onPrimaryButtonTap: () => navigateToRouter(),
      ),
    );
  }
}
