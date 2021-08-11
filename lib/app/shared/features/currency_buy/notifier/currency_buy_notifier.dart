import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../../screens/market/provider/currencies_pod.dart';
import '../../../components/balance_selector/model/selected_percent.dart';
import '../../../helpers/currencies_helpers.dart';
import '../../../helpers/input_helpers.dart';
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
    filterCurrencies(currencies, currencyModel);
    state = state.copyWith(currencies: currencies);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
  }

  void selectPercentFromBalance(SelectedPercent selected) {
    // TODO temporar (waiting for backend)
    if (state.selectedCurrency != null) {
      _logger.log(notifier, 'selectPercentFromBalance');

      final value = valueBasedOnSelectedPercent(
        selected: selected,
        currency: state.selectedCurrency!,
      );

      _updateInputValue(
        valueAccordingToAccuracy(value, state.selectedCurrency!.accuracy),
      );
      _validateInput();
      _calculateTargetConversion();
      _calculateBaseConversion();
    }
  }

  void resetValuesToZero() {
    _logger.log(notifier, 'resetValuesToZero');

    _updateInputValue(_zero);
    _updateTargetConversionValue(_zero);
    _updateBaseConversionValue(_zero);
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
        // TODO temporar (waiting for baseCurrency)
        accuracy: state.selectedCurrency == null
            ? 2
            : state.selectedCurrency!.accuracy,
      ),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  void updateTargetConversionPrice(double? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    state = state.copyWith(targetConversionPrice: price);
  }

  void _updateTargetConversionValue(String value) {
    state = state.copyWith(targetConversionValue: value);
  }

  void _calculateTargetConversion() {
    if (state.targetConversionPrice != null && state.inputValue.isNotEmpty) {
      final amount = double.parse(state.inputValue);
      final price = state.targetConversionPrice!;
      final accuracy = currencyModel.accuracy.toInt();

      _updateTargetConversionValue(
        truncateZerosFromInput(
          (amount / price).toStringAsFixed(accuracy),
        ),
      );
    } else {
      _updateTargetConversionValue(_zero);
    }
  }

  void updateBaseConversionPrice(double? price) {
    _logger.log(notifier, 'updateBaseConversionPrice');

    state = state.copyWith(baseConversionPrice: price);
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _calculateBaseConversion() {
    if (state.baseConversionPrice != null && state.inputValue.isNotEmpty) {
      final amount = double.parse(state.targetConversionValue);
      final price = state.baseConversionPrice!;
      const accuracy = 2; // TODO add dynamic accuracy

      _updateBaseConversionValue(
        truncateZerosFromInput(
          (amount * price).toStringAsFixed(accuracy),
        ),
      );
    } else {
      _updateBaseConversionValue(_zero);
    }
  }

  void _validateInput() {
    state = state.copyWith(
      inputValid:
          state.selectedCurrency != null && isInputValid(state.inputValue),
    );
  }
}
