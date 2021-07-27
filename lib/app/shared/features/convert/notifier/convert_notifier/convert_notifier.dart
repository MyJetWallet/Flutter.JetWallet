import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../service/services/swap/model/execute_quote/execute_quote_request_model.dart';
import '../../../../../../../../service/services/swap/model/get_quote/get_quote_request_model.dart';
import '../../../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../convert_input_notifier/convert_input_state.dart';
import 'convert_state.dart';
import 'convert_union.dart';

class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier(this.read) : super(const ConvertState());

  final Reader read;

  late Timer _timer;

  Future<void> requestQuote(
    ConvertInputState input, {
    bool init = false,
  }) async {
    state = state.copyWith(union: const QuoteLoading());

    final model = GetQuoteRequestModel(
      fromAssetAmount: double.parse(input.fromAssetAmount),
      fromAsset: input.fromAsset.symbol,
      toAsset: input.toAsset.symbol,
      isFromFixed: true,
    );

    try {
      final response = await read(swapServicePod).getQuote(model);

      state = state.copyWith(
        responseQuote: response,
        union: const QuoteSuccess(),
      );

      _refreshTimer(response.expirationTime);
    } catch (error) {
      state = state.copyWith(
        union: const QuoteError(),
        error: error.toString(),
      );
    }
  }

  Future<void> executeQuote() async {
    state = state.copyWith(union: const ExecuteLoading());

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: state.responseQuote!.operationId,
        price: state.responseQuote!.price,
        fromAsset: state.responseQuote!.fromAsset,
        toAsset: state.responseQuote!.toAsset,
        fromAssetAmount: state.responseQuote!.fromAssetAmount,
        toAssetAmount: state.responseQuote!.toAssetAmount,
        isFromFixed: true,
      );

      final response = await read(swapServicePod).executeQuote(model);

      if (response.isExecuted) {
        state = state.copyWith(union: const ExecuteSuccess());
      } else {
        state = state.copyWith(
          responseQuote: GetQuoteResponseModel(
            operationId: response.operationId,
            price: response.price,
            fromAsset: response.fromAsset,
            toAsset: response.toAsset,
            fromAssetAmount: response.fromAssetAmount,
            toAssetAmount: response.toAssetAmount,
            isFromFixed: response.isFromFixed,
            expirationTime: response.expirationTime,
          ),
        );

        state = state.copyWith(
          error: "Something wrong happend, but don't worry, "
              'we updated the price',
          union: const ExecuteError(),
        );
      }
    } catch (error) {
      state = state.copyWith(
        error: error.toString(),
        union: const ExecuteError(),
      );
    }
  }

  /// Called after [ExecuteError()]
  void emitQuoteUnion() {
    state = state.copyWith(
      union: state.timer > 1 ? const QuoteSuccess() : const QuoteError(),
    );
  }

  Future<void> _refreshQuote() async {
    state = state.copyWith(union: const QuoteRefresh());

    final quote = state.responseQuote!;

    final model = GetQuoteRequestModel(
      fromAssetAmount: quote.fromAssetAmount,
      fromAsset: quote.fromAsset,
      toAsset: quote.toAsset,
      isFromFixed: true,
    );

    try {
      final response = await read(swapServicePod).getQuote(model);

      state = state.copyWith(
        responseQuote: response,
        union: const QuoteSuccess(),
      );

      _refreshTimer(response.expirationTime);
    } catch (error) {
      state = state.copyWith(
        union: const QuoteRefresh(),
        error: error.toString(),
      );
      _refreshTimer(10);
    }
  }

  void _refreshTimer(int initial) {
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

  void cancelTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
