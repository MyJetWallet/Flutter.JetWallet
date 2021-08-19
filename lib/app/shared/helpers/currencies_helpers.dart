import '../models/currency_model.dart';

/// Used for [BUY] and [SELL] features
void sortCurrencies(List<CurrencyModel> currencies) {
  // If baseBalance of 2 assets are equal, compare by assetBalance
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;
    return b.assetBalance.compareTo(a.assetBalance);
  });
}

/// Used for [BUY] feature
void removeEmptyCurrenciesFrom(List<CurrencyModel> currencies) {
  currencies.removeWhere((element) => element.assetBalance == 0);
}

/// Used for [BUY] and [SELL] features
void removeCurrencyFrom(
  List<CurrencyModel> currencies,
  CurrencyModel currency,
) {
  currencies.removeWhere((element) => element.symbol == currency.symbol);
}
