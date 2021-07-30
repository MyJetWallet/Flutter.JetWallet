import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../../../service/services/swap/model/execute_quote/execute_quote_request_model.dart';
import '../../../../../../../../service/services/swap/model/get_quote/get_quote_request_model.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/logging/levels.dart';
import '../convert_input_notifier/convert_input_state.dart';
import 'convert_state.dart';
import 'convert_union.dart';

const _quoteErrorRetryInterval = 10;

class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier(this.read) : super(const ConvertState());

  final Reader read;

  Timer _timer = Timer(Duration.zero, () {});

  static final _logger = Logger('ConvertNotifier');

  void updateFrom(ConvertInputState input) {
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
      );

      _refreshTimer(response.expirationTime);
    } catch (error) {
      _logger.log(stateFlow, 'requestQuote', error);

      state = state.copyWith(
        union: const QuoteError(),
        error: error.toString(),
      );
      _refreshTimer(_quoteErrorRetryInterval);
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
        state = state.copyWith(union: const ExecuteSuccess());
      } else {
        state = state.copyWith(
          operationId: response.operationId,
          price: response.price,
          fromAssetSymbol: response.fromAssetSymbol,
          toAssetSymbol: response.toAssetSymbol,
          fromAssetAmount: response.fromAssetAmount,
          toAssetAmount: response.toAssetAmount,
          error: "Something wrong happend, but don't worry, "
              'we updated the price',
          union: const ExecuteError(),
        );
      }
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      state = state.copyWith(
        error: error.toString(),
        union: const ExecuteError(),
      );
    }
  }

  /// Called after [ExecuteError()]
  void emitQuoteUnion() {
    _logger.log(notifier, 'emitQuoteUnion');

    state = state.copyWith(
      union: state.timer > 1 ? const QuoteSuccess() : const QuoteError(),
    );
  }

  void cancelTimer() {
    _logger.log(notifier, 'cancelTimer');

    _timer.cancel();
  }

  Future<void> _refreshQuote() async {
    state = state.copyWith(union: const QuoteRefresh());

    final model = GetQuoteRequestModel(
      fromAssetAmount: state.fromAssetAmount,
      fromAssetSymbol: state.fromAssetSymbol!,
      toAssetSymbol: state.toAssetSymbol!,
      isFromFixed: true,
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
      );

      _refreshTimer(response.expirationTime);
    } catch (error) {
      state = state.copyWith(
        union: const QuoteRefresh(),
        error: error.toString(),
      );
      _refreshTimer(_quoteErrorRetryInterval);
    }
  }

  void _refreshTimer(int initial) {
    _timer.cancel();
    state = state.copyWith(timer: initial);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.timer == 0) {
          timer.cancel();
          _refreshQuote();
        } else {
          state = state.copyWith(
            timer: state.timer - 1,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
