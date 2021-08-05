import '../../screens/market/model/currency_model.dart';

void sortCurrencies(List<CurrencyModel> currencies) {
  // If baseBalance of 2 assets are equal, compare by assetBalance
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;
    return b.assetBalance.compareTo(a.assetBalance);
  });
}
