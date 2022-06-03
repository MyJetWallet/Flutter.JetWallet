import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/swap/model/execute_quote/execute_quote_request_model.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../components/quote_updated_dialog.dart';
import '../../model/preview_convert_input.dart';
import '../../view/convert.dart';
import 'preview_convert_state.dart';
import 'preview_convert_union.dart';

class PreviewConvertNotifier extends StateNotifier<PreviewConvertState> {
  PreviewConvertNotifier(
    this.input,
    this.read,
  ) : super(const PreviewConvertState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateFrom(input);
    requestQuote();
  }

  final Reader read;
  final PreviewConvertInput input;

  Timer _timer = Timer(Duration.zero, () {});
  late BuildContext _context;

  static final _logger = Logger('PreviewConvertNotifier');

  void _updateFrom(PreviewConvertInput input) {
    state = state.copyWith(
      fromAssetAmount: Decimal.parse(input.fromAmount),
      toAssetAmount: Decimal.parse(input.toAmount),
      fromAssetSymbol: input.fromCurrency.symbol,
      toAssetSymbol: input.toCurrency.symbol,
    );
  }

  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    state = state.copyWith(union: const QuoteLoading());

    final model = GetQuoteRequestModel(
      fromAssetAmount: input.toAssetEnabled ? null : state.fromAssetAmount,
      fromAssetSymbol: state.fromAssetSymbol!,
      toAssetSymbol: state.toAssetSymbol!,
      toAssetAmount: input.toAssetEnabled ? state.toAssetAmount : null,
      isFromFixed: !input.toAssetEnabled,
    );

    try {
      final intl = read(intlPod);
      final response = await read(swapServicePod).getQuote(
        model,
        intl.localeName,
      );

      state = state.copyWith(
        operationId: response.operationId,
        price: response.price,
        fromAssetSymbol: response.fromAssetSymbol,
        toAssetSymbol: response.toAssetSymbol,
        fromAssetAmount: response.fromAssetAmount,
        toAssetAmount: response.toAssetAmount,
        union: const QuoteSuccess(),
        connectingToServer: false,
        feeAsset: response.feeAsset,
        feeAmount: response.feeAmount,
        feePercent: response.feePercent,
      );

      _refreshTimerAnimation(response.expirationTime);
      _refreshTimer(response.expirationTime);
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestQuote', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'requestQuote', error);

      state = state.copyWith(
        union: const QuoteLoading(),
        connectingToServer: true,
      );

      _refreshTimer(quoteRetryInterval);
    }
  }

  Future<void> executeQuote() async {
    _logger.log(notifier, 'executeQuote');

    state = state.copyWith(union: const ExecuteLoading());

    final intl = read(intlPod);

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: state.operationId!,
        price: state.price!,
        fromAssetSymbol: state.fromAssetSymbol!,
        toAssetSymbol: state.toAssetSymbol!,
        fromAssetAmount: state.fromAssetAmount,
        toAssetAmount: state.toAssetAmount,
        isFromFixed: !input.toAssetEnabled,
      );

      final response = await read(swapServicePod).executeQuote(
        model,
        intl.localeName,
      );

      if (response.isExecuted) {
        _timer.cancel();
        _showSuccessScreen();
      } else {
        state = state.copyWith(union: const QuoteSuccess());
        _timer.cancel();
        if (!mounted) return;
        showQuoteUpdatedDialog(
          context: _context,
          onPressed: () => requestQuote(),
        );
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'executeQuote', error.cause);

      _timer.cancel();
      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      _timer.cancel();
      _showNoResponseScreen();
    }
  }

  void cancelTimer() {
    _logger.log(notifier, 'cancelTimer');

    _timer.cancel();
  }

  /// Will be triggered during initState of the parent widget
  void updateTimerAnimation(AnimationController controller) {
    state = state.copyWith(timerAnimation: controller);
  }

  /// Will be triggered only when timerAnimation is not Null
  void _refreshTimerAnimation(int duration) {
    state.timerAnimation!.duration = Duration(seconds: duration);
    state.timerAnimation!.countdown();
  }

  void _refreshTimer(int initial) {
    _timer.cancel();
    state = state.copyWith(timer: initial);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.timer == 0) {
          timer.cancel();
          requestQuote();
        } else {
          state = state.copyWith(
            timer: state.timer - 1,
          );
        }
      },
    );
  }

  void _showSuccessScreen() {
    final intl = read(intlPod);

    return SuccessScreen.push(
      context: _context,
      secondaryText: intl.previewConvert_orderProcessing,
      then: () {
        navigateToRouter(read);
      },
    );
  }

  void _showNoResponseScreen() {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.showNoResponseScreen_text,
      secondaryText: intl.showNoResponseScreen_text2,
      primaryButtonName: intl.serverCode0_ok,
      onPrimaryButtonTap: () {
        navigateToRouter(read);
      },
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.previewConvert_failure,
      secondaryText: error.cause,
      primaryButtonName: intl.previewConvert_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => const Convert(),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.previewConvert_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }

  String get previewHeader {
    final intl = read(intlPod);

    return '${intl.previewConvert_confirmConvert}\n'
        '${input.fromCurrency.symbol} ${intl.to} ${input.toCurrency.symbol}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
