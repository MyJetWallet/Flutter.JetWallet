import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

List<CurrencyModel> currenciesWithBalanceFrom(List<CurrencyModel> currencies) {
  final currenciesWithBalance = currencies
      .where(
        (currency) => currency.isAssetBalanceNotEmpty || currency.isPendingDeposit,
      )
      .toList();
  sortCurrencies(currenciesWithBalance);

  return currenciesWithBalance;
}
