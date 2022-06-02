import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../../models/currency_model.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import 'action_search_state.dart';

class ActionSearchNotifier extends StateNotifier<ActionSearchState> {
  ActionSearchNotifier({
    required this.read,
  }) : super(const ActionSearchState()) {
    _init();
  }

  final Reader read;

  void _init() {
    final currencies = read(currenciesPod);
    final buyFromCardCurrencies = <CurrencyModel>[];
    final receiveCurrencies = <CurrencyModel>[];
    final sendCurrencies = <CurrencyModel>[];

    for (final currency in currencies) {
      if (currency.supportsAtLeastOneBuyMethod) {
        buyFromCardCurrencies.add(currency);
      }
    }

    for (final currency in currencies) {
      if (currency.type == AssetType.crypto && currency.supportsCryptoDeposit) {
        receiveCurrencies.add(currency);
      }
    }

    for (final currency in currencies) {
      if (currency.isAssetBalanceNotEmpty &&
          currency.supportsCryptoWithdrawal) {
        sendCurrencies.add(currency);
      }
    }

    state = state.copyWith(
      currencies: currencies,
      filteredCurrencies: currencies,
      buyFromCardCurrencies: buyFromCardCurrencies,
      receiveCurrencies: receiveCurrencies,
      sendCurrencies: sendCurrencies,
    );
  }

  void search(String value) {
    if (value.isNotEmpty && state.filteredCurrencies.isNotEmpty) {
      final search = value.toLowerCase();

      final currencies = List<CurrencyModel>.from(state.currencies);

      currencies.removeWhere((element) {
        return !(element.description.toLowerCase()).startsWith(search) &&
            !(element.symbol.toLowerCase()).startsWith(search);
      });

      final buyFromCardCurrencies = <CurrencyModel>[];

      for (final element in currencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          buyFromCardCurrencies.add(element);
        }
      }

      state = state.copyWith(
        filteredCurrencies: currencies,
        buyFromCardCurrencies: buyFromCardCurrencies,
      );
    } else {
      state = state.copyWith(
        filteredCurrencies: state.currencies,
        buyFromCardCurrencies: state.currencies,
      );
    }
  }
}
