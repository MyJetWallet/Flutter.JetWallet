import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/high_yield/model/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import '../../../../../../service/services/high_yield/model/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../model/preview_return_to_wallet_input.dart';
import 'preview_return_to_wallet_state.dart';
import 'preview_return_to_wallet_union.dart';

class PreviewReturnToWalletNotifier
    extends StateNotifier<PreviewReturnToWalletState> {
  PreviewReturnToWalletNotifier(
    this.input,
    this.read,
  ) : super(const PreviewReturnToWalletState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateFrom(input);
    calculateEarnOfferApy();
  }

  final Reader read;
  final PreviewReturnToWalletInput input;

  late BuildContext _context;

  static final _logger = Logger('PreviewReturnToWalletNotifier');

  void _updateFrom(PreviewReturnToWalletInput input) {
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
      assetSymbol: read(baseCurrencyPod).symbol,
      amount: Decimal.parse(input.amount),
    );

    try {
      final response = await read(highYieldServicePod).calculateEarnOfferApy(
        model,
        read(intlPod).localeName,
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

  Future<void> earnOfferWithdrawal(String offerId) async {
    _logger.log(notifier, 'earnOfferWithdrawal');

    state = state.copyWith(union: const ExecuteLoading());

    try {
      final model = EarnOfferWithdrawalRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        offerId: offerId,
        assetSymbol: state.fromAssetSymbol ?? '',
        amount: state.fromAssetAmount ?? Decimal.zero,
      );

      await read(highYieldServicePod).earnOfferWithdrawal(
        model,
        read(intlPod).localeName,
      );

      _showSuccessScreen();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'earnOfferWithdrawal', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'earnOfferWithdrawal', error);

      _showFailureScreen(
        ServerRejectException(
          read(intlPod).preview_return_to_wallet_error,
        ),
      );
    }
  }

  void _showSuccessScreen() {
    return SuccessScreen.push(
      context: _context,
      secondaryText: read(intlPod).success_preview_return_to_wallet_message,
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    return FailureScreen.push(
      context: _context,
      primaryText: read(intlPod).failure_preview_return_to_wallet_message,
      secondaryText: error.cause,
      primaryButtonName: read(intlPod).failure_preview_return_to_wallet_close,
      onPrimaryButtonTap: () => navigateToRouter(read),
    );
  }
}
