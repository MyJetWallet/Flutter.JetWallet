import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../../screens/market/provider/currencies_pod.dart';
import '../../../components/balance_selector/model/selected_percent.dart';
import '../../../helpers/currencies_helpers.dart';
import '../../../helpers/input_helpers.dart';
import 'currency_sell_state.dart';

class CurrencySellNotifier extends StateNotifier<CurrencySellState> {
  CurrencySellNotifier(this.read, this.currencyModel)
      : super(const CurrencySellState()) {
    _updateCurrencies(read(currenciesPod));
  }

  final Reader read;
  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencyBuyNotifier');

  void _updateCurrencies(List<CurrencyModel> currencies) {
    sortCurrencies(currencies);
    removeCurrencyFrom(currencies, currencyModel);
    state = state.copyWith(currencies: currencies);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
  }

  void _updateInputValue(String value) {
    state = state.copyWith(inputValue: value);
  }

  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');

    _updateInputValue(
      responseOnInputAction(
        oldInput: state.inputValue,
        newInput: value,
        accuracy: currencyModel.accuracy,
      ),
    );
    _validateInput();
  }

  void selectPercentFromBalance(SelectedPercent selected) {
    if (state.selectedCurrency != null) {
      _logger.log(notifier, 'selectPercentFromBalance');

      final value = valueBasedOnSelectedPercent(
        selected: selected,
        currency: currencyModel,
      );

      _updateInputValue(
        valueAccordingToAccuracy(value, currencyModel.accuracy),
      );
      _validateInput();
    }
  }

  void _validateInput() {
    state = state.copyWith(
      inputValid: isInputValid(state.inputValue),
    );
  }
}
