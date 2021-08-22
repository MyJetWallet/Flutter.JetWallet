import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../components/balance_selector/model/selected_percent.dart';
import '../../../helpers/calculate_base_balance.dart';
import '../../../helpers/currencies_helpers.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import 'currency_sell_state.dart';

class CurrencySellNotifier extends StateNotifier<CurrencySellState> {
  CurrencySellNotifier(this.read, this.currencyModel)
      : super(const CurrencySellState()) {
    _initCurrencies();
    _initBaseCurrency();
  }

  final Reader read;
  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencySellNotifier');

  void _initCurrencies() {
    final currencies = read(currenciesPod);
    sortCurrencies(currencies);
    removeCurrencyFrom(currencies, currencyModel);
    state = state.copyWith(currencies: currencies);
  }

  void _initBaseCurrency() {
    state = state.copyWith(
      baseCurrency: read(baseCurrencyPod),
    );
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
    _validateInput();
  }

  void selectPercentFromBalance(SelectedPercent selected) {
    _logger.log(notifier, 'selectPercentFromBalance');

    final value = valueBasedOnSelectedPercent(
      selected: selected,
      currency: currencyModel,
    );

    _updateInputValue(
      valueAccordingToAccuracy(value, currencyModel.accuracy),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
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
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  void updateTargetConversionPrice(double? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    // needed to calculate conversion while switching between assets
    _calculateTargetConversion(price);
    state = state.copyWith(targetConversionPrice: price);
  }

  void _updateTargetConversionValue(String value) {
    state = state.copyWith(targetConversionValue: value);
  }

  void _calculateTargetConversion([double? newPrice]) {
    if ((state.targetConversionPrice != null || newPrice != null) &&
        state.inputValue.isNotEmpty) {
      final amount = double.parse(state.inputValue);
      final price = newPrice ?? state.targetConversionPrice!;
      final accuracy = state.selectedCurrencyAccuracy.toInt();
      final conversion = amount * price;

      _updateTargetConversionValue(
        truncateZerosFromInput(
          conversion.toStringAsFixed(accuracy),
        ),
      );
    } else {
      _updateTargetConversionValue(zeroCase);
    }
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _calculateBaseConversion() {
    if (state.inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        read: read,
        assetSymbol: currencyModel.symbol,
        assetBalance: double.parse(state.inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFromInput(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zeroCase);
    }
  }

  void _updateInputValid(bool value) {
    state = state.copyWith(inputValid: value);
  }

  void _updateInputError(InputError error) {
    state = state.copyWith(inputError: error);
  }

  void _validateInput() {
    final error = inputError(
      state.inputValue,
      currencyModel,
    );

    if (state.selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(state.inputValue),
        );
      } else {
        _updateInputValid(false);
      }
    }

    _updateInputError(error);
  }
}
