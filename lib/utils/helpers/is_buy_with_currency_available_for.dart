import '../models/currency_model.dart';

/// Checks whether user has at least 2 currencies with the balance.
/// Or 1 currency with the balance if this currency != argument currency.
bool isBuyWithCurrencyAvailableFor(
  String symbol,
  List<CurrencyModel> currencies,
) {
  final array = currencies.where((e) => e.isAssetBalanceNotEmpty);

  if (array.length > 1) {
    return true;
  } else if (array.length == 1) {
    return array.first.symbol != symbol;
  } else {
    return false;
  }
}
