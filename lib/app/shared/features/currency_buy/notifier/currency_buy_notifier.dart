import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../../screens/market/provider/currencies_pod.dart';
import '../../../components/balance_selector/model/selected_percent.dart';
import '../../../helpers/input_helpers.dart';
import '../../../helpers/sort_currencies.dart';
import 'currency_buy_state.dart';

const _zero = '0';

class CurrencyBuyNotifier extends StateNotifier<CurrencyBuyState> {
  CurrencyBuyNotifier(this.read, this.currencyModel)
      : super(const CurrencyBuyState()) {
    _updateCurrencies(read(currenciesPod));
  }

  final Reader read;
  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencyBuyNotifier');

  void _updateCurrencies(List<CurrencyModel> currencies) {
    sortCurrencies(currencies);
    currencies.removeWhere((element) {
      return element.assetBalance == 0 && element.symbol != 'USD';
    });
    currencies.removeWhere((element) => element == currencyModel);
    state = state.copyWith(currencies: currencies);
    updateSelectedCurrency(currencies.first);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
  }

  void selectPercentFromBalance(SelectedPercent selected) {
    _logger.log(notifier, 'selectPercentFromBalance');

    final value = valueBasedOnSelectedPercent(
      selected: selected,
      currency: state.selectedCurrency!,
    );

    _updateInputValue(
      valueAccordingToAccuracy(value, state.selectedCurrency!.accuracy),
    );
    _validateInput();
    _calculateConversion();
  }

  void resetValuesToZero() {
    _logger.log(notifier, 'resetValuesToZero');

    _updateInputValue(_zero);
    _updateConvertedValue(_zero);
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
        accuracy: state.selectedCurrency!.accuracy,
      ),
    );
    _validateInput();
    _calculateConversion();
  }

  void updateConversionPrice(double? price) {
    _logger.log(notifier, 'updateConversionPrice');

    state = state.copyWith(converstionPrice: price);
  }

  void _updateConvertedValue(String value) {
    state = state.copyWith(convertedValue: value);
  }

  void _calculateConversion() {
    if (state.converstionPrice != null) {
      if (state.inputValue.isNotEmpty) {
        final amount = double.parse(state.inputValue);
        final price = state.converstionPrice!;
        final accuracy = currencyModel.accuracy.toInt();

        _updateConvertedValue(
          truncateZerosFromInput(
            (amount / price).toStringAsFixed(accuracy),
          ),
        );
      } else {
        _updateConvertedValue(_zero);
      }
    }
  }

  void _validateInput() {
    state = state.copyWith(
      inputValid: isInputValid(state.inputValue),
    );
  }
}
