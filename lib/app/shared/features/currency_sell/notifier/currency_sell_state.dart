import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../helpers/format_asset_price_value.dart';

import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';

part 'currency_sell_state.freezed.dart';

@freezed
class CurrencySellState with _$CurrencySellState {
  const factory CurrencySellState({
    BaseCurrencyModel? baseCurrency,
    CurrencyModel? selectedCurrency,
    double? targetConversionPrice,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default('0') String inputValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
    @Default(InputError.none) InputError inputError,
  }) = _CurrencySellState;

  const CurrencySellState._();

  String get selectedCurrencySymbol {
    if (selectedCurrency == null) {
      return baseCurrency!.symbol;
    } else {
      return selectedCurrency!.symbol;
    }
  }

  int get selectedCurrencyAccuracy {
    if (selectedCurrency == null) {
      return baseCurrency!.accuracy;
    } else {
      return selectedCurrency!.accuracy;
    }
  }

  String conversionText() {
    final base = formatPriceValue(
      prefix: baseCurrency!.symbol,
      value: num.parse(baseConversionValue),
      accuracy: baseCurrency!.accuracy,
    );

    if (selectedCurrency == null) {
      return base;
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return base;
    } else {
      return '≈ $targetConversionValue ${selectedCurrency!.symbol} ($base)';
    }
  }
}
