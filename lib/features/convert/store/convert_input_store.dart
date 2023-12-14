// ignore_for_file: use_setters_to_change_properties

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/convert/helper/remove_currency_from_list.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/i10n.dart';
part 'convert_input_store.g.dart';

class ConvertInputStore extends _ConvertInputStoreBase with _$ConvertInputStore {
  ConvertInputStore(super.fromCurrency);

  static _ConvertInputStoreBase of(BuildContext context) => Provider.of<ConvertInputStore>(context, listen: false);
}

abstract class _ConvertInputStoreBase with Store {
  _ConvertInputStoreBase(this.fromCurrency) {
    final tempCurrencies = sSignalRModules.currenciesList;

    sortCurrencies(tempCurrencies);

    final toList = tempCurrencies;
    final s1 = tempCurrencies.toList();
    //s1.sort((a, b) => b.weight.compareTo(a.weight));
    sortByBalanceAndWeight(s1);

    final to = (fromCurrency?.symbol == toList[1].symbol || tempCurrencies.first.symbol == toList[1].symbol)
        ? toList[0]
        : s1[1];
    //    _currencies.first.symbol == toList[1].symbol)
    //? toList[0]
    //: s1.last;

    final fromList = tempCurrencies;

    fromAsset = fromCurrency ?? tempCurrencies.first;
    fromAssetList = fromList;
    toAsset = to;
    toAssetList = toList;
    currencies = ObservableList.of(tempCurrencies);

    setUpdateTargetConversionPrice(
      fromAsset!.symbol,
      toAsset!.symbol,
    );
  }

  static final _logger = Logger('ConvertInputStore');

  CurrencyModel? fromCurrency;

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  Decimal? converstionPrice;

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

  @computed
  CurrencyModel? get _currentAsset => fromAssetEnabled ? fromAsset : toAsset;

  @computed
  String get _currentAssetAmount => fromAssetEnabled ? fromAssetAmount : toAssetAmount;

  @observable
  List<CurrencyModel> fromAssetList = [];

  @observable
  List<CurrencyModel> toAssetList = [];

  @computed
  Decimal? get _minLimit => fromAssetEnabled ? fromAsset?.minTradeAmount : toAsset?.minTradeAmount;

  @computed
  Decimal? get _maxLimit => fromAssetEnabled ? fromAsset?.maxTradeAmount : toAsset?.maxTradeAmount;

  @observable
  String limitError = '';

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

    final tempFromAsset = toAsset;
    final tempToAsset = fromAsset;
    final tempFromList = List<CurrencyModel>.from(toAssetList);
    final tempToList = List<CurrencyModel>.from(fromAssetList);
    final tempFromAmount = toAssetAmount;
    final tempToAmount = fromAssetAmount;

    fromAsset = tempFromAsset;
    toAsset = tempToAsset;
    fromAssetList = tempFromList;
    toAssetList = tempToList;
    fromAssetAmount = tempFromAmount;
    toAssetAmount = tempToAmount;

    _validateInput();

    setUpdateTargetConversionPrice(
      fromAsset!.symbol,
      toAsset!.symbol,
    );
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
    _validateInput(isFrom: true);
  }

  @action
  void enableToAsset() {
    _logger.log(notifier, 'enableToAsset');

    toAssetEnabled = true;
    fromAssetEnabled = false;

    _truncateZerosOfAssetAmount();

    setUpdateTargetConversionPrice(
      fromAsset!.symbol,
      toAsset!.symbol,
    );
    _validateInput();
  }

  @action
  void enableFromAsset() {
    _logger.log(notifier, 'enableFromAsset');

    toAssetEnabled = false;
    fromAssetEnabled = true;

    _truncateZerosOfAssetAmount();

    setUpdateTargetConversionPrice(
      fromAsset!.symbol,
      toAsset!.symbol,
    );
    _validateInput();
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
  void _validateInput({
    bool isFrom = false,
  }) {
    final error = onTradeInputErrorHandler(
      fromAssetAmount,
      fromAsset!,
    );

    if (fromAssetAmount.isNotEmpty) {
      final value = Decimal.parse(fromAssetAmount);

      if (fromAsset?.minTradeAmount != null && fromAsset!.minTradeAmount! > value) {
        limitError = '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: fromAsset!.minTradeAmount!,
          accuracy: fromAsset?.accuracy ?? 0,
          symbol: fromAsset?.symbol ?? '',
        )}';
      } else if (fromAsset?.maxTradeAmount != null && fromAsset!.maxTradeAmount! < value) {
        limitError = '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: fromAsset!.maxTradeAmount!,
          accuracy: fromAsset?.accuracy ?? 1,
          symbol: fromAsset?.symbol ?? '',
        )}';
      } else {
        limitError = '';
      }

      final withAmmountInputError = double.parse(fromAssetAmount) != 0
          ? error == InputError.none
              ? limitError.isEmpty
                  ? InputError.none
                  : InputError.limitError
              : error
          : InputError.none;

      if (withAmmountInputError == InputError.none) {
        _convertValid(
          isInputValid(fromAssetAmount),
        );
      } else {
        _convertValid(false);
      }

      _updateInputError(withAmmountInputError);
    }

    setUpdateTargetConversionPrice(
      fromAsset!.symbol,
      toAsset!.symbol,
    );
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
}
