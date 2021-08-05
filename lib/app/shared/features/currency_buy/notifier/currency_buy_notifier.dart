import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/market/model/currency_model.dart';
import '../../../../screens/market/provider/currencies_pod.dart';
import '../../../helpers/sort_currencies.dart';
import 'currency_buy_state.dart';

class CurrencyBuyNotifier extends StateNotifier<CurrencyBuyState> {
  CurrencyBuyNotifier(this.read) : super(const CurrencyBuyState()) {
    _updateCurrencies(read(currenciesPod));
  }

  final Reader read;

  void _updateCurrencies(List<CurrencyModel> currencies) {
    sortCurrencies(currencies);
    state = state.copyWith(currencies: currencies);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    state = state.copyWith(selectedCurrency: currency);
  }
}
