import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

part 'currency_sell_store.g.dart';

class CirrencySellStore extends _CirrencySellStoreBase
    with _$CirrencySellStore {
  CirrencySellStore(super.currencyModel);

  static _CirrencySellStoreBase of(BuildContext context) =>
      Provider.of<CirrencySellStore>(context, listen: false);
}

abstract class _CirrencySellStoreBase with Store {
  _CirrencySellStoreBase(this.currencyModel) {
    _initCurrencies();
    _initBaseCurrency();
  }

  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencyStore');

  @observable
  Decimal? targetConversionPrice;

  @observable
  BaseCurrencyModel? baseCurrency;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  SKeyboardPreset? selectedPreset;

  @observable
  String? tappedPreset;

  @observable
  String inputValue = '0';

  @observable
  String targetConversionValue = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool inputValid = false;

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  InputError inputError = InputError.none;

  @computed
  String get selectedCurrencySymbol {
    return selectedCurrency == null
        ? baseCurrency!.symbol
        : selectedCurrency!.symbol;
  }

  @computed
  int get selectedCurrencyAccuracy {
    return selectedCurrency == null
        ? baseCurrency!.accuracy
        : selectedCurrency!.accuracy;
  }

  @action
  String conversionText() {
    final base = volumeFormat(
      accuracy: baseCurrency!.accuracy,
      prefix: baseCurrency?.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );

    if (selectedCurrency == null) {
      return '≈ $base';
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return '≈ $base';
    } else {
      final target = volumeFormat(
        decimal: Decimal.parse(targetConversionValue),
        symbol: selectedCurrency!.symbol,
        prefix: selectedCurrency!.prefixSymbol,
        accuracy: selectedCurrency!.accuracy,
      );

      return '≈ $target ($base)';
    }
  }

  @action
  void _initCurrencies() {
    final _currencies = List<CurrencyModel>.from(
      sSignalRModules.currenciesList,
    );
    sortCurrencies(_currencies);
    removeCurrencyFrom(_currencies, currencyModel);

    currencies = ObservableList.of(_currencies);
  }

  @action
  void _initBaseCurrency() {
    baseCurrency = sSignalRModules.baseCurrency;
  }

  @action
  void tapPreset(String presetName) {
    tappedPreset = presetName;
  }

  @action
  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    selectedCurrency = currency;
    _validateInput();
  }

  @action
  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final _percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      selected: _percent,
      currency: currencyModel,
    );

    _updateInputValue(
      valueAccordingToAccuracy(value, currencyModel.accuracy),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  void _updateSelectedPreset(SKeyboardPreset preset) {
    selectedPreset = preset;
  }

  @action
  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
  }

  @action
  void _updateInputValue(String value) {
    inputValue = value;
  }

  @action
  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');

    _updateInputValue(
      responseOnInputAction(
        oldInput: inputValue,
        newInput: value,
        accuracy: currencyModel.accuracy,
      ),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  @action
  Future<void> setUpdateTargetConversionPrice(
    String symbol,
    String selectedCurrencySymbol,
  ) async {
    final price = await getConversionPrice(
      ConversionPriceInput(
        baseAssetSymbol: symbol,
        quotedAssetSymbol: selectedCurrencySymbol,
      ),
    );

    updateTargetConversionPrice(price);
  }

  @action
  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    // needed to calculate conversion while switching between assets
    _calculateTargetConversion(price);
    targetConversionPrice = price;
  }

  @action
  void _updateTargetConversionValue(String value) {
    targetConversionValue = value;
  }

  @action
  void _calculateTargetConversion([Decimal? newPrice]) {
    if ((targetConversionPrice != null || newPrice != null) &&
        inputValue.isNotEmpty) {
      final amount = Decimal.parse(inputValue);
      final price = newPrice ?? targetConversionPrice!;
      final accuracy = selectedCurrencyAccuracy;

      final conversion = amount * price;

      _updateTargetConversionValue(
        truncateZerosFrom(
          conversion.toStringAsFixed(accuracy),
        ),
      );
    } else {
      _updateTargetConversionValue(zero);
    }
  }

  @action
  void _updateBaseConversionValue(String value) {
    baseConversionValue = value;
  }

  @action
  void _calculateBaseConversion() {
    if (inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: currencyModel.symbol,
        assetBalance: Decimal.parse(inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  @action
  void _updateInputValid(bool value) {
    inputValid = value;
  }

  @action
  void _updateInputError(InputError error) {
    inputError = error;
  }

  @action
  void _validateInput() {
    final error = onTradeInputErrorHandler(
      inputValue,
      currencyModel,
    );

    if (selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(inputValue),
        );
      } else {
        _updateInputValid(false);
      }
    }

    _updateInputError(error);
  }

  @action
  void _clearPercent() {
    selectedPreset = null;
  }
}
