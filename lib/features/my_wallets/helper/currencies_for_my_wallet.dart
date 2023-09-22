import 'package:jetwallet/utils/models/currency_model.dart';

List<CurrencyModel> currenciesForMyWallet(List<CurrencyModel> currencies) {
  final activeCurrencies = currencies
      .where(
        (currency) => currency.walletIsActive,
      )
      .toList();

  activeCurrencies
      .sort((a, b) => (a.walletOrder ?? 1).compareTo(b.walletOrder ?? 1));

  return activeCurrencies;
}
