import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/swap/model/execute_quote/execute_quote_request_model.dart';
import '../../../../../service/services/swap/model/get_quote/get_quote_request_model.dart';
import '../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../service/services/swap/service/swap_service.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../screens/wallet/model/currency_model.dart';
import '../helpers/remove_element.dart';
import 'convert_state.dart';
import 'convert_union.dart';

class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier({
    required this.defaultState,
    required this.currencies,
    required this.swapService,
  }) : super(defaultState);

  final ConvertState defaultState;
  final List<CurrencyModel> currencies;
  final SwapService swapService;

  static final _logger = Logger('ConvertNotifier');

  void updateFrom(CurrencyModel from) {
    _logger.log(notifier, 'updateFrom');

    state = state.copyWith(from: from);
    _updateToList();
  }

  void updateTo(CurrencyModel to) {
    _logger.log(notifier, 'updateTo');

    state = state.copyWith(to: to);
    _updateFromList();
  }

  void switchFromTo() {
    _logger.log(notifier, 'switchFromTo');

    final newFrom = state.to;
    final newTo = state.from;
    final newFromList = List<CurrencyModel>.from(state.toList);
    final newToList = List<CurrencyModel>.from(state.fromList);

    state = state.copyWith(
      from: newFrom,
      to: newTo,
      fromList: newFromList,
      toList: newToList,
    );
  }

  void updateAmount(String amount) {
    _logger.log(notifier, 'updateAmount');

    state = state.copyWith(amount: double.parse(amount));
  }

  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    try {
      state = state.copyWith(union: const Loading());

      final model = GetQuoteRequestModel(
        fromAsset: state.from.symbol,
        toAsset: state.to.symbol,
        fromAssetAmount: state.amount ?? 0,
        isFromFixed: true,
      );

      final response = await swapService.getQuote(model);

      state = state.copyWith(
        quoteResponse: response,
        union: const ResponseQuote(),
      );
    } catch (e) {
      _logger.log(stateFlow, 'requestQuote', e);

      state = state.copyWith(union: RequestQuote('$e'));
    }
  }

  /// Return [true] if convert was successful else [false]
  Future<String> executeQuote() async {
    _logger.log(notifier, 'executeQuote');

    try {
      state = state.copyWith(isConfirmLoading: true);

      final quote = state.quoteResponse!;

      final model = ExecuteQuoteRequestModel(
        operationId: quote.operationId,
        price: quote.price,
        fromAsset: quote.fromAsset,
        toAsset: quote.toAsset,
        fromAssetAmount: quote.fromAssetAmount,
        toAssetAmount: quote.toAssetAmount,
        isFromFixed: quote.isFromFixed,
      );

      final response = await swapService.executeQuote(model);

      if (response.isExecuted) {
        toRequestQuote();
        return 'Convert was successful';
      } else {
        state = state.copyWith(
          quoteResponse: GetQuoteResponseModel(
            operationId: response.operationId,
            price: response.price,
            fromAsset: response.fromAsset,
            toAsset: response.toAsset,
            fromAssetAmount: response.fromAssetAmount,
            toAssetAmount: response.toAssetAmount,
            isFromFixed: response.isFromFixed,
            expirationTime: response.expirationTime,
          ),
          isConfirmLoading: false,
        );

        return "Something wrong happend, but don't worry, we updated the price";
      }
    } catch (e) {
      _logger.log(stateFlow, 'executeQuote', e);

      toRequestQuote();
      return e.toString();
    }
  }

  void cleanError() {
    _logger.log(notifier, 'cleanError');

    state = state.copyWith(union: const RequestQuote());
  }

  void toRequestQuote() {
    _logger.log(notifier, 'toRequestQuote');

    state.amountTextController.clear();

    state = state.copyWith(
      union: const RequestQuote(),
      quoteResponse: null,
      amount: 0.0,
      isConfirmLoading: false,
    );
  }

  void _updateFromList() {
    final newFromList = removeElement(state.to, currencies);

    state = state.copyWith(fromList: newFromList);
  }

  void _updateToList() {
    final newToList = removeElement(state.from, currencies);

    state = state.copyWith(toList: newToList);
  }
}
