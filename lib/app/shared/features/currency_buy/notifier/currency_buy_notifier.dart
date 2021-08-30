import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../components/balance_selector/model/selected_percent.dart';
import '../../../helpers/calculate_base_balance.dart';
import '../../../helpers/currencies_helpers.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import 'currency_buy_state.dart';

class CurrencyBuyNotifier extends StateNotifier<CurrencyBuyState> {
  CurrencyBuyNotifier(this.read, this.currencyModel)
      : super(const CurrencyBuyState()) {
    _initCurrencies();
    _initBaseCurrency();
    _initDefaultPaymentMethod();
  }

  final Reader read;
  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencyBuyNotifier');

  void _initCurrencies() {
    final currencies = List<CurrencyModel>.from(
      read(currenciesPod),
    );
    sortCurrencies(currencies);
    removeEmptyCurrenciesFrom(currencies);
    removeCurrencyFrom(currencies, currencyModel);
    state = state.copyWith(currencies: currencies);
  }

  void _initBaseCurrency() {
    state = state.copyWith(
      baseCurrency: read(baseCurrencyPod),
    );
  }

  void _initDefaultPaymentMethod() {
    if (state.currencies.isNotEmpty) {
      // Case 1: If use has baseCurrency wallet with balance more than zero
      for (final currency in state.currencies) {
        if (currency.symbol == state.baseCurrency!.symbol) {
          updateSelectedCurrency(currency);
          return;
        }
      }

      // Case 2: If user has at least one fiat wallet
      for (final currency in state.currencies) {
        if (currency.type == AssetType.fiat) {
          updateSelectedCurrency(currency);
          return;
        }
      }

      // TODO Case 3: If user has at least one saved card

      // Case 4: If user has at least one crypto wallet
      updateSelectedCurrency(state.currencies.first);
    }
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
  }

  void selectPercentFromBalance(SelectedPercent selected) {
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

  void _updateInputValue(String value) {
    state = state.copyWith(inputValue: value);
  }

  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');

    _updateInputValue(
      responseOnInputAction(
        oldInput: state.inputValue,
        newInput: value,
        accuracy: state.selectedCurrencyAccuracy,
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
      final accuracy = currencyModel.accuracy;
      var conversion = 0.0;

      if (price != 0) {
        conversion = amount / price;
      }

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
        assetSymbol: state.selectedCurrencySymbol,
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
    if (state.selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      final error = inputError(
        state.inputValue,
        state.selectedCurrency!,
      );

      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(state.inputValue),
        );
      } else {
        _updateInputValid(false);
      }

      _updateInputError(error);
    }
  }

  void resetValuesToZero() {
    _logger.log(notifier, 'resetValuesToZero');

    _updateInputValue(zeroCase);
    _updateTargetConversionValue(zeroCase);
    _updateBaseConversionValue(zeroCase);
  }
}
