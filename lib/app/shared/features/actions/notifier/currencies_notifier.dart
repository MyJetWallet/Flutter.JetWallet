import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/currency_model.dart';

class CurrenciesNotifier extends StateNotifier<List<CurrencyModel>> {
  CurrenciesNotifier({
    required this.read,
    required this.currencies,
    required this.search,
  }) : super(<CurrencyModel>[]) {
    init(currencies);
  }

  final Reader read;
  final List<CurrencyModel> currencies;
  final String search;

  void init(List<CurrencyModel> currencies) {
    if (search.isNotEmpty) {
      filter(search);
    } else {
      state = currencies;
    }
  }

  void filter(String value) {
    final search = value.toLowerCase();

    currencies.removeWhere(
      (element) =>
          !(element.description.toLowerCase()).startsWith(search) &&
          !(element.symbol.toLowerCase()).startsWith(search),
    );

    state = currencies;
  }
}
