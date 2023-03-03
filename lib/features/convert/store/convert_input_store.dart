// ignore_for_file: use_setters_to_change_properties

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/convert/helper/remove_currency_from_list.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
part 'convert_input_store.g.dart';

class ConvertInputStore extends _ConvertInputStoreBase
    with _$ConvertInputStore {
  ConvertInputStore(super.fromCurrency);

  static _ConvertInputStoreBase of(BuildContext context) =>
      Provider.of<ConvertInputStore>(context, listen: false);
}

abstract class _ConvertInputStoreBase with Store {
  _ConvertInputStoreBase(this.fromCurrency) {
    final _currencies = sSignalRModules.currenciesList;

    sortCurrencies(_currencies);

    final toList = _currencies;
    final to = (fromCurrency?.symbol == toList[1].symbol ||
      _currencies.first.symbol == toList[1].symbol)
      ? toList[0] : toList[1];
    final fromList = _currencies;

    fromAsset = fromCurrency ?? _currencies.first;
    fromAssetList = fromList;
    toAsset = to;
    toAssetList = toList;
    currencies = ObservableList.of(_currencies);
  }

  static final _logger = Logger('ConvertInputStore');

  CurrencyModel? fromCurrency;

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  Decimal? converstionPrice;

  @observable
  SKeyboardPreset? selectedPreset;

  @observable
  String? tappedPreset;

  @observable
  String fromAssetAmount = '';

  @observable
  String toAssetAmount = '';

  @observable
  bool fromAssetEnabled = true;

  @observable
  bool toAssetEnabled = false;

  @observable
  bool convertValid = false;

  @observable
  InputError inputError = InputError.none;

  @observable
  CurrencyModel? fromAsset;

  @observable
  CurrencyModel? toAsset;

  @observable
  List<CurrencyModel> fromAssetList = [];

  @observable
  List<CurrencyModel> toAssetList = [];

  @action
  void _updateFromAssetAmount(String value) {
    fromAssetAmount = value;
  }

  @action
  void _updateToAssetAmount(String value) {
    toAssetAmount = value;
  }

  @action
  void _updateFromAsset(CurrencyModel value) {
    fromAsset = value;
  }

  @action
  void _updateToAsset(CurrencyModel value) {
    toAsset = value;
  }

  @action
  Future<void> setUpdateTargetConversionPrice(
    String symbol,
    String selectedCurrencySymbol,
  ) async {
    _updateConverstionPrice(
      await getConversionPrice(
        ConversionPriceInput(
          baseAssetSymbol: symbol,
          quotedAssetSymbol: selectedCurrencySymbol,
        ),
      ),
    );
    _calculateConversion();
  }

  @action
  void _updateConverstionPrice(Decimal? value) {
    converstionPrice = value;
  }

  @action
  void _convertValid(bool value) {
    convertValid = value;
  }

  @action
  void _updateInputError(InputError error) {
    inputError = error;
  }

  @action
  void tapPreset(String presetName) {
    tappedPreset = presetName;
  }

  /// ConversionPrice can be null if request to API failed
  @action
  void updateConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateConversionPrice');

    _updateConverstionPrice(price);
    _calculateConversion();
  }

  @action
  void switchFromAndTo() {
    _logger.log(notifier, 'switchFromAndTo');

    updateConversionPrice(null);

    final _fromAsset = toAsset;
    final _toAsset = fromAsset;
    final _fromList = List<CurrencyModel>.from(toAssetList);
    final _toList = List<CurrencyModel>.from(fromAssetList);
    final _fromAmount = toAssetAmount;
    final _toAmount = fromAssetAmount;

    fromAsset = _fromAsset;
    toAsset = _toAsset;
    fromAssetList = _fromList;
    toAssetList = _toList;
    fromAssetAmount = _fromAmount;
    toAssetAmount = _toAmount;

    _validateInput();
  }

  @action
  void updateFromAsset(CurrencyModel value) {
    _logger.log(notifier, 'updateFromAsset');

    updateConversionPrice(null);
    _updateFromAsset(value);
    if (fromAssetEnabled) {
      _resetAssetsAmount();
    } else {
      setUpdateTargetConversionPrice(
        fromAsset!.symbol,
        toAsset!.symbol,
      );
    }
    _validateInput();
  }

  @action
  void updateToAsset(CurrencyModel value) {
    _logger.log(notifier, 'updateToAsset');

    updateConversionPrice(null);
    _updateToAsset(value);
    if (toAssetEnabled) {
      _resetAssetsAmount();
    } else {
      setUpdateTargetConversionPrice(
        fromAsset!.symbol,
        toAsset!.symbol,
      );
    }
    _validateInput();
  }

  @action
  void updateFromAssetAmount(String amount) {
    _logger.log(notifier, 'updateFromAssetAmount');

    _updateFromAssetAmount(
      responseOnInputAction(
        oldInput: fromAssetAmount,
        newInput: amount,
        accuracy: fromAsset!.accuracy,
      ),
    );
    _calculateConversion();
    _validateInput();
    _clearPercent();
  }

  @action
  void updateToAssetAmount(String amount) {
    _logger.log(notifier, 'updateToAssetAmount');

    _updateToAssetAmount(
      responseOnInputAction(
        oldInput: toAssetAmount,
        newInput: amount,
        accuracy: toAsset!.accuracy,
      ),
    );
    _calculateConversion();
    _validateInput();
    _clearPercent();
  }

  @action
  void enableToAsset() {
    _logger.log(notifier, 'enableToAsset');

    toAssetEnabled = true;
    fromAssetEnabled = false;

    _truncateZerosOfAssetAmount();
  }

  @action
  void enableFromAsset() {
    _logger.log(notifier, 'enableFromAsset');

    toAssetEnabled = false;
    fromAssetEnabled = true;

    _truncateZerosOfAssetAmount();
  }

  /// We can select percent only from FromAssetAmount
  @action
  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);

    if (fromAssetEnabled) {
      final value = valueBasedOnSelectedPercent(
        selected: percent,
        currency: fromAsset!,
      );

      _updateFromAssetAmount(value);
      _calculateConversion();
      _updateAmountsAccordingToAccuracy();
      _validateInput();
    }
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
  void _truncateZerosOfAssetAmount() {
    if (fromAssetEnabled) {
      _updateToAssetAmount(
        truncateZerosFrom(toAssetAmount),
      );
    } else {
      _updateFromAssetAmount(
        truncateZerosFrom(fromAssetAmount),
      );
    }
  }

  @action
  void _updateAmountsAccordingToAccuracy() {
    _updateFromAssetAmount(
      valueAccordingToAccuracy(
        fromAssetAmount,
        fromAsset!.accuracy,
      ),
    );
    _updateToAssetAmount(
      valueAccordingToAccuracy(
        toAssetAmount,
        toAsset!.accuracy,
      ),
    );
  }

  @action
  void _calculateConversion() {
    if (converstionPrice != null) {
      if (fromAssetEnabled) {
        if (fromAssetAmount.isNotEmpty) {
          _calculateConversionOfToAsset();
          _truncateZerosOfAssetAmount();
        } else {
          _resetAssetsAmount();
        }
      } else {
        if (toAssetAmount.isNotEmpty) {
          _calculateConversionOfFromAsset();
          _truncateZerosOfAssetAmount();
        } else {
          _resetAssetsAmount();
        }
      }
    }
  }

  @action
  void _calculateConversionOfToAsset() {
    final amount = Decimal.parse(fromAssetAmount);
    final price = converstionPrice!;
    final accuracy = toAsset!.accuracy;

    final result = amount * price;

    toAssetAmount = result.toStringAsFixed(accuracy);
  }

  @action
  void _calculateConversionOfFromAsset() {
    final amount = Decimal.parse(toAssetAmount);
    final price = converstionPrice!;
    final accuracy = fromAsset!.accuracy;

    var result = Decimal.zero;

    if (price != Decimal.zero) {
      result = (amount / price).toDecimal(
        scaleOnInfinitePrecision: accuracy,
      );
    }

    fromAssetAmount = result.toString();
  }

  /// Called when backspace erases everything
  @action
  void _resetAssetsAmount() {
    fromAssetAmount = '';
    toAssetAmount = '';
  }

  @action
  void _validateInput() {
    final error = onTradeInputErrorHandler(
      fromAssetAmount,
      fromAsset!,
    );

    if (error == InputError.none) {
      _convertValid(
        isInputValid(fromAssetAmount),
      );
    } else {
      _convertValid(false);
    }

    _updateInputError(error);
  }

  @action
  void _updateFromList() {
    final newList = removeCurrencyFromList(toAsset!, currencies);

    fromAssetList = newList;
  }

  @action
  void _updateToList() {
    final newList = removeCurrencyFromList(fromAsset!, currencies);

    toAssetList = newList;
  }

  @action
  void _clearPercent() {
    selectedPreset = null;
  }
}
