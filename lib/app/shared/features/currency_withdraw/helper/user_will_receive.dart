import '../../../models/currency_model.dart';

// TODO what to do with the fee from different currency?
// In order to do this we need to have conversion from asset to asset
// that we don't have right now. Discuss this matter with Alexey.

/// Calculates amount that user will receive after
/// subtraction of the currency fee
String userWillreceive(String amount, CurrencyModel currency) {
  final value = double.parse(amount);
  final fee = currency.fees.withdrawalFee?.size ?? 0;

  return '${value - fee} ${currency.symbol}';
}
