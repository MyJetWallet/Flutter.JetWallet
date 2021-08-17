import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

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
import '../../../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../view/components/convert_preview/components/quote_updated_dialog.dart';
import '../../view/convert.dart';
import '../convert_input_notifier/convert_input_state.dart';
import 'convert_state.dart';
import 'convert_union.dart';

class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier(
    this.input,
    this.read,
  ) : super(const ConvertState()) {
    _context = read(navigatorKeyPod).currentContext!;
    updateFrom(input);
    requestQuote();
  }

  final Reader read;
  final ConvertInputState input;

  Timer _timer = Timer(Duration.zero, () {});
  late BuildContext _context;

  static final _logger = Logger('ConvertNotifier');

  String get header {
    return 'Convert ${state.fromAssetSymbol} to ${state.toAssetSymbol}';
  }

  void updateFrom(ConvertInputState input) {
    _logger.log(notifier, 'updateFrom');

    state = state.copyWith(
      fromAssetAmount: double.parse(input.fromAssetAmount),
      fromAssetSymbol: input.fromAsset.symbol,
      toAssetSymbol: input.toAsset.symbol,
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
        // ignore: use_build_context_synchronously
        showQuoteUpdatedDialog(
          context: _context,
          onPressed: () => requestQuote(),
        );
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'executeQuote', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      _showNoResponseScreen();
    }
  }

  void cancelTimer() {
    _logger.log(notifier, 'cancelTimer');

    _timer.cancel();
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
      SuccessScreen(
        header: header,
        description: 'Order filled',
      ),
    );
  }

  void _showNoResponseScreen() {
    return navigatorPush(
      _context,
      NoResponseFromServer(
        header: header,
        description: 'Failed to place Order',
        onOk: () {
          read(navigationStpod).state = 1; // Portfolio
          navigateToRouter(read(navigatorKeyPod));
        },
      ),
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    return navigatorPush(
      _context,
      FailureScreen(
        header: header,
        description: error.cause,
        firstButtonName: 'Edit Order',
        onFirstButton: () {
          Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(
              builder: (_) => const Convert(),
            ),
            (route) => route.isFirst,
          );
        },
        secondButtonName: 'Close',
        onSecondButton: () => navigateToRouter(read(navigatorKeyPod)),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
