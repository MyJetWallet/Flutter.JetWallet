import '../../../helpers/input_helpers.dart';

import '../../../models/currency_model.dart';

/// Calculates amount that user will receive after
/// subtraction of the currency fee
String userWillreceive(String amount, CurrencyModel currency) {
  if (amount.isNotEmpty) {
    final value = double.parse(amount);

    var fee = currency.withdrawalFeeSize;

    if (value <= fee) {
      return '0 ${currency.symbol}';
    } else {
      if (currency.isFeeInOtherCurrency) fee = 0;

      final result = (value - fee).toStringAsFixed(currency.accuracy);
      final truncated = truncateZerosFromInput(result);

      return '$truncated ${currency.symbol}';
    }
  } else {
    return '0 ${currency.symbol}';
  }
}
