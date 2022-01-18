import '../../app/shared/helpers/currencies_helpers.dart';
import '../../app/shared/models/currency_model.dart';

List<CurrencyModel> currenciesWithBalanceFrom(List<CurrencyModel> currencies) {
  final currenciesWithBalance =
      currencies.where((currency) => currency.isAssetBalanceNotEmpty).toList();
  sortCurrencies(currenciesWithBalance);

  return currenciesWithBalance;
}
