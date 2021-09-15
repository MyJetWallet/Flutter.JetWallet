import '../../../models/currency_model.dart';

/// Used when [InputError.enterHigherAmount]
String minimumAmount(CurrencyModel currency) {
  if (currency.isFeeInOtherCurrency) {
    return 'No minimum';
  } else {
    return 'Min ${currency.withdrawalFeeSize} ${currency.symbol}';
  }
}
