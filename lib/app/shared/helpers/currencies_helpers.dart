import '../../screens/market/model/currency_model.dart';

/// Used for [BUY] and [SELL] features
void sortCurrencies(List<CurrencyModel> currencies) {
  // If baseBalance of 2 assets are equal, compare by assetBalance
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;
    return b.assetBalance.compareTo(a.assetBalance);
  });
}

/// Used for [BUY] and [SELL] features
void filterCurrencies(List<CurrencyModel> currencies, CurrencyModel currency) {
  currencies.removeWhere((element) {
    /// The base currency will be always persistent (USD)
    return element.assetBalance == 0 && element.symbol != 'USD';
  });
  currencies.removeWhere((element) => element == currency);
}
