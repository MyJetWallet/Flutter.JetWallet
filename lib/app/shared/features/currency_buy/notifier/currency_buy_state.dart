import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';

part 'currency_buy_state.freezed.dart';

@freezed
class CurrencyBuyState with _$CurrencyBuyState {
  const factory CurrencyBuyState({
    double? targetConversionPrice,
    BaseCurrencyModel? baseCurrency,
    CurrencyModel? selectedCurrency,
    @Default('') String inputValue,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
    @Default(InputError.none) InputError inputError,
  }) = _CurrencyBuyState;

  const CurrencyBuyState._();

  String get selectedCurrencySymbol {
    if (selectedCurrency == null) {
      return baseCurrency!.symbol;
    } else {
      return selectedCurrency!.symbol;
    }
  }

  double get selectedCurrencyAccuracy {
    if (selectedCurrency == null) {
      return baseCurrency!.accuracy;
    } else {
      return selectedCurrency!.accuracy;
    }
  }

  String conversionText(CurrencyModel currency) {
    final target = '≈ $targetConversionValue ${currency.symbol} ';
    final base = '$baseConversionValue ${baseCurrency!.symbol}';

    if (selectedCurrency == null) {
      return target;
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return target;
    } else {
      return '$target ($base)';
    }
  }
}
