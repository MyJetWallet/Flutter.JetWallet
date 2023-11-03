import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
part 'convert_amount_store.g.dart';

class ConvertAmountStore extends _ConvertAmountStoreBase with _$ConvertAmountStore {
  ConvertAmountStore() : super();

  static ConvertAmountStore of(BuildContext context) => Provider.of<ConvertAmountStore>(context, listen: false);
}

abstract class _ConvertAmountStoreBase with Store {
  @observable
  bool disableSubmit = false;
  @action
  bool setDisableSubmit(bool value) => disableSubmit = value;

  @observable
  String? paymentMethodInputError;

  @observable
  Decimal? targetConversionPrice;

  @observable
  InputError inputError = InputError.none;

  @observable
  String? errorText;

  @observable
  bool inputValid = false;

  @observable
  bool isFromEntering = true;

  @observable
  String fromInputValue = '0';

  @observable
  String toInputValue = '0';

  @computed
  String get primaryAmount {
    return isFromEntering ? fromInputValue : toInputValue;
  }

  @computed
  String get primarySymbol {
    return isFromEntering ? fromAsset?.symbol ?? '' : toAsset?.symbol ?? '';
  }

  @computed
  String get secondaryAmount {
    return isFromEntering ? toInputValue : fromInputValue;
  }

  @computed
  String get secondarySymbol {
    return isFromEntering ? toAsset?.symbol ?? '' : fromAsset?.symbol ?? '';
  }

  @computed
  Decimal get _availablePresentForProcessing => Decimal.one - ((convertMarkup / Decimal.parse('100')).toDecimal());

  @observable
  CurrencyModel? fromAsset;

  @observable
  CurrencyModel? toAsset;

  @action
  void init({
    CurrencyModel? inputAsset,
  }) {
    fromAsset = inputAsset;
  }

  @action
  void setNewFromAsset(CurrencyModel newAsset) {
    fromAsset = newAsset;

    loadConversionPrice();

    toInputValue = '0';
    fromInputValue = '0';
    errorText = null;
    inputValid = false;
  }

  @action
  void swapAssets() {
    if (toAsset == null) {
      return;
    }
    isFromEntering = !isFromEntering;
    _validateInput();
  }

  @action
  void setNewToAsset(CurrencyModel newAsset) {
    toAsset = newAsset;

    loadConversionPrice();

    toInputValue = '0';
    fromInputValue = '0';
    errorText = null;
    inputValid = false;
  }

  @action
  Future<void> loadConversionPrice() async {
    if (fromAsset != null && toAsset != null) {
      targetConversionPrice = await getConversionPrice(
        ConversionPriceInput(
          baseAssetSymbol: fromAsset?.symbol ?? '',
          quotedAssetSymbol: toAsset?.symbol ?? '',
        ),
      );
    }
  }

  @computed
  String get inputErrorValue {
    return paymentMethodInputError != null ? paymentMethodInputError! : inputError.value();
  }

  @computed
  bool get isInputErrorActive {
    return inputError.isActive || paymentMethodInputError != null;
  }

  @action
  void onConvetrAll() {
    fromInputValue = responseOnInputAction(
      oldInput: fromInputValue,
      newInput: maxLimit.toString(),
      accuracy: fromAsset?.accuracy ?? 2,
    );

    _calculateToConversion();

    _validateInput();
  }

  @action
  void updateInputValue(String value) {
    if (isFromEntering) {
      fromInputValue = responseOnInputAction(
        oldInput: fromInputValue,
        newInput: value,
        accuracy: fromAsset?.accuracy ?? 2,
      );
    } else {
      toInputValue = responseOnInputAction(
        oldInput: toInputValue,
        newInput: value,
        accuracy: toAsset?.accuracy ?? 2,
      );
    }
    if (isFromEntering) {
      _calculateToConversion();
    } else {
      _calculateFromConversion();
    }

    _validateInput();
  }

  @action
  void _calculateToConversion() {
    if (targetConversionPrice != null && fromInputValue != '0') {
      final amount = Decimal.parse(fromInputValue);
      final price = targetConversionPrice!;
      final accuracy = toAsset?.accuracy ?? 2;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        conversion = Decimal.parse(
          (amount * price).toStringAsFixed(accuracy),
        );
      }

      toInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      toInputValue = zero;
    }
  }

  void _calculateFromConversion() {
    if (targetConversionPrice != null && toInputValue != '0') {
      final amount = Decimal.parse(toInputValue);
      final price = targetConversionPrice!;
      final accuracy = fromAsset?.accuracy ?? 2;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        final koef = amount.toDouble() / price.toDouble();
        conversion = Decimal.parse(
          koef.toStringAsFixed(accuracy),
        );
      }

      fromInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      fromInputValue = zero;
    }
  }

  @computed
  Decimal get minLimit {
    return fromAsset?.minTradeAmount ?? Decimal.zero;
  }

  @computed
  Decimal get maxLimit {
    final assetBalance = fromAsset?.assetBalance ?? Decimal.zero;
    final maxTradeAmount = fromAsset?.maxTradeAmount ?? Decimal.zero;

    return (assetBalance < maxTradeAmount ? assetBalance : maxTradeAmount) * _availablePresentForProcessing;
  }

  @action
  void _validateInput() {
    if (Decimal.parse(fromInputValue) == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(fromInputValue)) {
      inputValid = false;

      return;
    }

    final value = Decimal.parse(fromInputValue);

    inputValid = value >= minLimit && value <= maxLimit;

    if (maxLimit == Decimal.zero) {
      _updatePaymentMethodInputError(
        intl.limitIsExceeded,
      );
    } else if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: minLimit,
          accuracy: fromAsset?.accuracy ?? 2,
          symbol: fromAsset?.symbol ?? '',
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: maxLimit,
          accuracy: fromAsset?.accuracy ?? 2,
          symbol: fromAsset?.symbol ?? '',
        )}',
      );
    } else {
      _updatePaymentMethodInputError(null);
    }

    const error = InputError.none;

    inputError = double.parse(fromInputValue) != 0
        ? error == InputError.none
            ? paymentMethodInputError == null
                ? InputError.none
                : InputError.limitError
            : error
        : InputError.none;
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    if (error != null) {
      sAnalytics.newBuyErrorLimit(
        errorCode: error,
        asset: fromAsset?.symbol ?? '',
        paymentMethodType: 'crypto',
        paymentMethodName: 'crypto',
        paymentMethodCurrency: fromAsset?.symbol ?? '',
      );
    }
    paymentMethodInputError = error;
  }
}
