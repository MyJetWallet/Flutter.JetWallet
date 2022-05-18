import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/high_yield/model/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import '../../../../../../service/services/high_yield/model/earn_offer_deposit/earn_offer_deposit_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../model/preview_high_yield_buy_input.dart';
import 'preview_high_yield_buy_state.dart';
import 'preview_high_yield_buy_union.dart';

class PreviewHighYieldBuyNotifier
    extends StateNotifier<PreviewHighYieldBuyState> {
  PreviewHighYieldBuyNotifier(
    this.input,
    this.read,
  ) : super(const PreviewHighYieldBuyState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateFrom(input);
    calculateEarnOfferApy();
  }

  final Reader read;
  final PreviewHighYieldBuyInput input;

  late BuildContext _context;

  static final _logger = Logger('PreviewHighYieldBuyNotifier');

  void _updateFrom(PreviewHighYieldBuyInput input) {
    state = state.copyWith(
      fromAssetAmount: Decimal.parse(input.amount),
      fromAssetSymbol: input.fromCurrency.symbol,
      toAssetSymbol: input.toCurrency.symbol,
    );
  }

  Future<void> calculateEarnOfferApy() async {
    _logger.log(notifier, 'calculateEarnOfferApy');

    state = state.copyWith(union: const QuoteLoading());

    final model = CalculateEarnOfferApyRequestModel(
      offerId: input.earnOffer.offerId,
      assetSymbol: input.fromCurrency.symbol,
      amount: Decimal.parse(input.amount),
    );

    try {
      final response = await read(highYieldServicePod).calculateEarnOfferApy(
        model,
      );

      state = state.copyWith(
        apy: response.apy,
        expectedYearlyProfit: response.expectedYearlyProfit,
        expectedYearlyProfitBase: response.expectedYearlyProfitBaseAsset,
        union: const QuoteSuccess(),
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', error.cause);

      read(sNotificationNotipod.notifier).showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', error);

      read(sNotificationNotipod.notifier).showError(
        error.toString(),
        id: 1,
      );
    }
  }

  Future<void> earnOfferDeposit(String offerId) async {
    _logger.log(notifier, 'earnOfferDeposit');

    state = state.copyWith(union: const ExecuteLoading());

    try {
      final model = EarnOfferDepositRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        offerId: offerId,
        assetSymbol: state.fromAssetSymbol ?? '',
        amount: state.fromAssetAmount ?? Decimal.zero,
      );

      await read(highYieldServicePod).earnOfferDeposit(model);

      _showSuccessScreen();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'earnOfferDeposit', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'earnOfferDeposit', error);

      _showFailureScreen(const ServerRejectException('Some error occurred.'));
    }
  }

  /// Will be triggered during initState of the parent widget
  void updateTimerAnimation(AnimationController controller) {
    state = state.copyWith(timerAnimation: controller);
  }

  void _showSuccessScreen() {
    return SuccessScreen.push(
      context: _context,
      secondaryText: 'You has been subscribed',
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    return FailureScreen.push(
      context: _context,
      primaryText: 'Failure',
      secondaryText: error.cause,
      primaryButtonName: 'Close',
      onPrimaryButtonTap: () => navigateToRouter(read),
    );
  }
}
