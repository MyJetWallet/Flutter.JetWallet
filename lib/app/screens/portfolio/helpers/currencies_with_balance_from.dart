import '../../../shared/models/currency_model.dart';

List<CurrencyModel> currenciesWithBalanceFrom(List<CurrencyModel> currencies) {
  final currenciesWithBalance = currencies
      .where((currency) => currency.isAssetBalanceNotEmpty)
      .toList();
  currenciesWithBalance.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));

  return currenciesWithBalance;
}
