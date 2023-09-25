import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';

ObservableList<CurrencyModel> currenciesForMyWallet(
  ObservableList<CurrencyModel> currencies,
) {
  final activeCurrencies = currencies
      .where(
        (currency) => currency.walletIsActive,
      )
      .toList();

  activeCurrencies
      .sort((a, b) => (a.walletOrder ?? 1).compareTo(b.walletOrder ?? 1));

  return ObservableList.of(activeCurrencies);
}

ObservableList<CurrencyModel> currenciesForSearchInMyWallet(
  ObservableList<CurrencyModel> currencies,
) {
  final activeCurrencies = currencies
      .where(
        (currency) => !currency.walletIsActive,
      )
      .toList();

  activeCurrencies
      .sort((a, b) => (a.walletOrder ?? 1).compareTo(b.walletOrder ?? 1));

  return ObservableList.of(activeCurrencies);
}
