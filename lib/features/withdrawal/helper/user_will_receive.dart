import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

/// Calculates amount that user will receive after
/// subtraction of the currency fee
String userWillreceive({
  required String amount,
  required CurrencyModel currency,
  required String network,
}) {
  final value = Decimal.parse(amount);

  final fee = currency.withdrawalFeeSize(network: network, amount: value);

  if (value <= fee) {
    return '0 ${currency.symbol}';
  } else {
    final result = (value - fee).toStringAsFixed(currency.accuracy);
    final truncated = truncateZerosFrom(result);

    return '$truncated ${currency.symbol}';
  }
}
