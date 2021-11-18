import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../service/services/swap/model/execute_quote/execute_quote_request_model.dart';
import '../../../../../../../../service/services/swap/model/get_quote/get_quote_request_model.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screens/failure_screen.dart';
import '../../../../../../shared/components/result_screens/failure_screens/no_response_from_server.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../components/convert_preview/view/components/quote_updated_dialog.dart';
import '../../model/preview_buy_with_asset_input.dart';
import '../../view/curency_buy.dart';
import 'preview_buy_with_asset_state.dart';
import 'preview_buy_with_asset_union.dart';

class PreviewBuyWithAssetNotifier
    extends StateNotifier<PreviewBuyWithAssetState> {
  PreviewBuyWithAssetNotifier(
    this.input,
    this.read,
  ) : super(const PreviewBuyWithAssetState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateFrom(input);
    requestQuote();
  }

  final Reader read;
  final PreviewBuyWithAssetInput input;

  Timer _timer = Timer(Duration.zero, () {});
  late BuildContext _context;

  static final _logger = Logger('PreviewBuyWithAssetNotifier');

  void _updateFrom(PreviewBuyWithAssetInput input) {
    state = state.copyWith(
      fromAssetAmount: double.parse(input.fromAssetAmount),
      fromAssetSymbol: input.fromAssetSymbol,
      toAssetSymbol: input.currency.symbol,
    );
  }

  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    state = state.copyWith(union: const QuoteLoading());

    final model = GetQuoteRequestModel(
      fromAssetAmount: state.fromAssetAmount,
      fromAssetSymbol: state.fromAssetSymbol!,
      toAssetSymbol: state.toAssetSymbol!,
    );

    try {
      final response = await read(swapServicePod).getQuote(model);

      state = state.copyWith(
        operationId: response.operationId,
        price: response.price,
        fromAssetSymbol: response.fromAssetSymbol,
        toAssetSymbol: response.toAssetSymbol,
        fromAssetAmount: response.fromAssetAmount,
        toAssetAmount: response.toAssetAmount,
        union: const QuoteSuccess(),
        connectingToServer: false,
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

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: state.operationId!,
        price: state.price!,
        fromAssetSymbol: state.fromAssetSymbol!,
        toAssetSymbol: state.toAssetSymbol!,
        fromAssetAmount: state.fromAssetAmount!,
        toAssetAmount: state.toAssetAmount!,
      );

      final response = await read(swapServicePod).executeQuote(model);

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
    return navigatorPush(
      _context,
      const SuccessScreen(
        text1: 'Order filled',
      ),
      () {
        read(navigationStpod).state = 1;
        Navigator.pop(_context);
      },
    );
  }

  void _showNoResponseScreen() {
    return navigatorPush(
      _context,
      NoResponseFromServer(
        description: 'Failed to place Order',
        onOk: () {
          read(navigationStpod).state = 1; // Portfolio
          navigateToRouter(read);
        },
      ),
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    return navigatorPush(
      _context,
      FailureScreen(
        description: error.cause,
        firstButtonName: 'Edit Order',
        onFirstButton: () {
          Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(
              builder: (_) => CurrencyBuy(
                currency: input.currency,
              ),
            ),
            (route) => route.isFirst,
          );
        },
        secondButtonName: 'Close',
        onSecondButton: () => navigateToRouter(read),
      ),
    );
  }

  String get previewHeader {
    return 'Confirm Buy ${input.currency.description}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
