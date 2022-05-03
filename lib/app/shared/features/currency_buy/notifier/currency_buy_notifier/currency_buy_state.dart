import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_payment_methods.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';

part 'currency_buy_state.freezed.dart';

@freezed
class CurrencyBuyState with _$CurrencyBuyState {
  const factory CurrencyBuyState({
    Decimal? targetConversionPrice,
    BaseCurrencyModel? baseCurrency,
    PaymentMethod? selectedPaymentMethod,
    CurrencyModel? selectedCurrency,
    SKeyboardPreset? selectedPreset,
    String? paymentMethodInputError,
    @Default(RecurringBuysType.oneTimePurchase)
        RecurringBuysType recurringBuyType,
    @Default('0') String inputValue,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
    @Default(InputError.none) InputError inputError,
  }) = _CurrencyBuyState;

  const CurrencyBuyState._();

  String get preset1Name {
    if (selectedPaymentMethod != null) {
      return '\$50';
    } else {
      return '25%';
    }
  }

  String get preset2Name {
    if (selectedPaymentMethod != null) {
      return '\$100';
    } else {
      return '50%';
    }
  }

  String get preset3Name {
    if (selectedPaymentMethod != null) {
      return '\$500';
    } else {
      return '100%';
    }
  }

  bool get isInputErrorActive {
    if (inputError.isActive) {
      return true;
    } else {
      if (paymentMethodInputError != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  String get inputErrorValue {
    if (paymentMethodInputError != null) {
      return paymentMethodInputError!;
    } else {
      return inputError.value;
    }
  }

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

  String conversionText(CurrencyModel currency) {
    final target = marketFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: currency.symbol,
      prefix: currency.prefixSymbol,
      accuracy: currency.accuracy,
    );

    final base = marketFormat(
      accuracy: baseCurrency!.accuracy,
      prefix: baseCurrency!.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );

    if (selectedCurrency == null) {
      return '≈ $target';
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return '≈ $target';
    } else {
      return '≈ $target ($base)';
    }
  }
}
