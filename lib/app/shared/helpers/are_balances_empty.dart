import '../models/currency_model.dart';

/// Checks whether user has any assets with the balance
bool areBalancesEmpty(List<CurrencyModel> currencies) {
  for (final currency in currencies) {
    if (currency.isAssetBalanceNotEmpty) {
      return false;
    }
  }
  return true;
}
