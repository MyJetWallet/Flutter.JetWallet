import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/currency_model.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import 'action_search_state.dart';

class ActionSearchNotifier extends StateNotifier<ActionSearchState> {
  ActionSearchNotifier({
    required this.read,
  }) : super(const ActionSearchState(currencies: <CurrencyModel>[])) {
    _init();
  }

  final Reader read;

  void _init() {
    final currencies = read(currenciesPod);

    state = state.copyWith(
      currencies: currencies,
      filteredCurrencies: currencies,
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

      state = state.copyWith(filteredCurrencies: currencies);
    } else {
      state = state.copyWith(filteredCurrencies: state.currencies);
    }
  }
}
