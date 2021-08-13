import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../../screens/market/provider/currencies_pod.dart';
import '../../../components/balance_selector/model/selected_percent.dart';
import '../../../helpers/currencies_helpers.dart';
import '../../../helpers/input_helpers.dart';
import '../../../providers/base_asset_pod/base_asset_pod.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import 'currency_buy_state.dart';

const _zero = '0';

class CurrencyBuyNotifier extends StateNotifier<CurrencyBuyState> {
  CurrencyBuyNotifier(this.read, this.currencyModel)
      : super(const CurrencyBuyState()) {
    _initCurrencies();
    _initBaseCurrency();
    _fetchBaseConversionPrice();
  }

  final Reader read;
  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencyBuyNotifier');

  void _initCurrencies() {
    final currencies = read(currenciesPod);
    sortCurrencies(currencies);
    removeEmptyCurrenciesFrom(currencies);
    removeCurrencyFrom(currencies, currencyModel);
    state = state.copyWith(currencies: currencies);
  }

  void _initBaseCurrency() {
    state = state.copyWith(
      baseCurrency: read(baseAssetPod),
    );
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
      final accuracy = currencyModel.accuracy.toInt();
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
      _updateTargetConversionValue(_zero);
    }
  }

  void _fetchBaseConversionPrice() {
    read(
      conversionPriceFpod(
        ConversionPriceInput(
          targetAssetSymbol: currencyModel.symbol,
          quotedAssetSymbol: state.baseCurrency!.symbol,
          then: _updateBaseConversionPrice,
        ),
      ),
    );
  }

  void _updateBaseConversionPrice(double? price) {
    state = state.copyWith(baseConversionPrice: price);
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _calculateBaseConversion() {
    if (state.baseConversionPrice != null && state.inputValue.isNotEmpty) {
      final amount = double.parse(state.targetConversionValue);
      final price = state.baseConversionPrice!;
      final accuracy = state.baseCurrency!.accuracy.toInt();

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
