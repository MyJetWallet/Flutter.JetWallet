import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/swap/model/execute_quote/execute_quote_request_model.dart';
import '../../../../../service/services/swap/model/get_quote/get_quote_request_model.dart';
import '../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../service/services/swap/service/swap_service.dart';
import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../helpers/quote_timer.dart';
import '../helpers/sorted_list_of_currencies.dart';
import 'convert_state.dart';
import 'convert_union.dart';

// TODO consider to refactor this notifier to smaller ones
class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier({
    required this.defaultState,
    required this.currencies,
    required this.swapService,
  }) : super(defaultState);

  final ConvertState defaultState;
  final List<AssetWithBalanceModel> currencies;
  final SwapService swapService;

  void updateFrom(AssetWithBalanceModel from) {
    state = state.copyWith(from: from);
    _updateToList();
  }

  void updateTo(AssetWithBalanceModel to) {
    state = state.copyWith(to: to);
    _updateFromList();
  }

  void switchFromTo() {
    final newFrom = state.to;
    final newTo = state.from;
    final newFromList = List<AssetWithBalanceModel>.from(state.toList);
    final newToList = List<AssetWithBalanceModel>.from(state.fromList);

    state = state.copyWith(
      from: newFrom,
      to: newTo,
      fromList: newFromList,
      toList: newToList,
    );
  }

  void updateAmount(String amount) {
    state = state.copyWith(amount: double.parse(amount));
  }

  Future<void> requestQuote() async {
    state = state.copyWith(union: const Loading());

    final model = GetQuoteRequestModel(
      fromAsset: state.from.symbol,
      toAsset: state.to.symbol,
      fromAssetAmount: state.amount ?? 0,
      isFromFixed: true,
    );

    try {
      final response = await swapService.getQuote(model);
      state = state.copyWith(
        quoteResponse: response,
        union: const ResponseQuote(),
        quoteTime: quoteTimer(
          response.expirationTimer - 1,
        ).asBroadcastStream(),
      );
    } catch (e) {
      state = state.copyWith(union: RequestQuote('$e'));
    }
  }

  /// Return [true] if convert was successful else [false]
  Future<String> executeQuote() async {
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

    try {
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
            expirationTimer: response.expirationTimer,
          ),
          quoteTime: quoteTimer(
            response.expirationTimer - 1,
          ).asBroadcastStream(),
        );

        return "Something wrong happend, but don't worry, we updated the price";
      }
    } catch (e) {
      toRequestQuote();
      return e.toString();
    }
  }

  void cleanError() {
    state = state.copyWith(union: const RequestQuote());
  }

  void toRequestQuote() {
    state.amountTextController.clear();

    state = state.copyWith(
      union: const RequestQuote(),
      quoteResponse: null,
      quoteTime: null,
      amount: 0.0,
    );
  }

  void _updateFromList() {
    final newFromList = sortedListOfCurrencies(currencies, state.to);

    state = state.copyWith(fromList: newFromList);
  }

  void _updateToList() {
    final newToList = sortedListOfCurrencies(currencies, state.from);

    state = state.copyWith(toList: newToList);
  }
}
