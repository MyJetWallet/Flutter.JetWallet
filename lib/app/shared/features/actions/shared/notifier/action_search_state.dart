import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/currency_model.dart';

part 'action_search_state.freezed.dart';

@freezed
class ActionSearchState with _$ActionSearchState {
  const factory ActionSearchState({
    @Default([]) List<CurrencyModel> filteredCurrencies,
    required List<CurrencyModel> currencies,
  }) = _ActionSearchState;
}
