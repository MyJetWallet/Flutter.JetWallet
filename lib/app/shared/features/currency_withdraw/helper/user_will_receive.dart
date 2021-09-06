import '../../../models/currency_model.dart';

/// Calculates amount that user will receive after
/// subtraction of the currency fee
String userWillreceive(String amount, CurrencyModel currency) {
  final value = double.parse(amount);
  final fee = currency.fees.withdrawalFee?.size ?? 0;

  return '${value - fee} ${currency.symbol}';
}
