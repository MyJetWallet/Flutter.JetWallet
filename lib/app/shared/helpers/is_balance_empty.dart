import '../models/currency_model.dart';

/// Checks whether user has any asset on the balance
bool isBalanceEmpty(List<CurrencyModel> currencies) {
  for (final currency in currencies) {
    if (currency.isAssetBalanceNotEmpty) {
      return false;
    }
  }
  return true;
}
