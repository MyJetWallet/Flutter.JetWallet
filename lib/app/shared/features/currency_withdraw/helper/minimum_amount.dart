import '../../../models/currency_model.dart';

/// Used when [InputError.enterHigherAmount]
String minAmount(CurrencyModel currency) {
  if (currency.isFeeInOtherCurrency) {
    return 'No minimum';
  } else {
    return 'Min ${currency.withdrawalFeeSize} ${currency.symbol}';
  }
}
