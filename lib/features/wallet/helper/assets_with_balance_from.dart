import 'package:jetwallet/utils/models/currency_model.dart';

/// Value can't be null because this function is invoked on the screens
/// [Wallet] where at least one currency with balance exists. On other screens
/// can throw: BadStateException.
List<CurrencyModel> sortedCurrenciesWithBalanceFrom(
  List<CurrencyModel> currencies,
  String? currencyId,
) {
  final currenciesWithBalance = currencies.where((currency) => !currency.isAssetBalanceEmpty).toList();
  final currency = currenciesWithBalance.firstWhere((currency) => currency.symbol == currencyId);

  currenciesWithBalance.removeWhere((currency) => currency.symbol == currencyId);
  currenciesWithBalance.insert(0, currency);

  return currenciesWithBalance;
}
