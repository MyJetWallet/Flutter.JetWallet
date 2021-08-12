import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../screens/market/model/currency_model.dart';

part 'currency_sell_state.freezed.dart';

@freezed
class CurrencySellState with _$CurrencySellState {
  const factory CurrencySellState({
    CurrencyModel? selectedCurrency,
    @Default('') String inputValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
  }) = _CurrencySellState;
}
