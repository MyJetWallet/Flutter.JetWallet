import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/high_yield/model/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
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
    initBaseData();
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

  Future<void> initBaseData() async {
    _logger.log(notifier, 'initBaseData');
    state = state.copyWith(
      union: const QuoteSuccess(),
    );
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

      sAnalytics.earnSuccessReclaim(
        assetName: input.fromCurrency.description,
        amount: input.amount,
        offerId: input.earnOffer.offerId,
        apy: input.apy,
        term: input.earnOffer.term,
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
