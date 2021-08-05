import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../screens/market/model/currency_model.dart';

part 'currency_buy_state.freezed.dart';

@freezed
class CurrencyBuyState with _$CurrencyBuyState {
  const factory CurrencyBuyState({
    CurrencyModel? selectedCurrency,
    @Default([]) List<CurrencyModel> currencies,
  }) = _CurrencyBuyState;
}
