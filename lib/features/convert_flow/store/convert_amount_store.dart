import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/swap_limits_request_model.dart';
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

  @computed
  bool get isContinueAvaible {
    return inputValid &&
        Decimal.parse(primaryAmount) != Decimal.zero &&
        fromAsset != null &&
        targetConversionPrice != null;
  }

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
    return isFromEntering ? fromAsset?.symbol ?? 'EUR' : toAsset?.symbol ?? 'EUR';
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
  int get primaryAccuracy {
    return isFromEntering ? fromAsset?.accuracy ?? 2 : toAsset?.accuracy ?? 2;
  }

  @computed
  int get secondaryAccuracy {
    return isFromEntering ? toAsset?.accuracy ?? 2 : fromAsset?.accuracy ?? 2;
  }

  @observable
  CurrencyModel? fromAsset;

  @observable
  CurrencyModel? toAsset;

  @action
  void init({
    CurrencyModel? newFromAsset,
    CurrencyModel? newToAsset,
  }) {
    toAsset = newToAsset;
    fromAsset = newFromAsset;

    if (fromAsset == null && toAsset != null) {
      isFromEntering = false;
    }

    _checkShowTosts();
  }

  @observable
  bool isNoCurrencies = false;

  @action
  void _checkShowTosts() {
    isNoCurrencies = !sSignalRModules.currenciesList.any((currency) {
      return currency.assetBalance != Decimal.zero;
    });
    if (isNoCurrencies) {
      sAnalytics.errorYourCryptoBalanceIsZeroPleaseGetCryptoFirst();
      Timer(
        const Duration(milliseconds: 200),
        () {
          sNotification.showError(
            intl.tost_convert_message_1,
            id: 1,
          );
        },
      );
    }
  }

  @action
  void setNewFromAsset(CurrencyModel newAsset) {
    fromAsset = newAsset;

    loadConversionPrice();
    loadLimits();

    toInputValue = '0';
    fromInputValue = '0';
    errorText = null;
    inputValid = false;
  }

  @action
  void swapAssets() {
    if (toAsset == null || fromAsset == null) {
      return;
    }
    isFromEntering = !isFromEntering;
    _validateInput();
  }

  @action
  void setNewToAsset(CurrencyModel newAsset) {
    toAsset = newAsset;

    loadConversionPrice();
    loadLimits();

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
      newInput: convertAllAmount.toString(),
      accuracy: fromAsset?.accuracy ?? 2,
    );

    isFromEntering = true;

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
        wholePartLenght: maxWholePrartLenght,
      );
    } else {
      toInputValue = responseOnInputAction(
        oldInput: toInputValue,
        newInput: value,
        accuracy: toAsset?.accuracy ?? 2,
        wholePartLenght: maxWholePrartLenght,
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
  Decimal get convertAllAmount {
    return fromAsset?.assetBalance ?? Decimal.zero;
  }

  @observable
  Decimal _minFromAssetVolume = Decimal.zero;

  @observable
  Decimal _maxFromAssetVolume = Decimal.zero;

  @observable
  Decimal _minToAssetVolume = Decimal.zero;

  @observable
  Decimal _maxToAssetVolume = Decimal.zero;

  @computed
  Decimal get minLimit => isFromEntering ? _minFromAssetVolume : _minToAssetVolume;

  @computed
  Decimal get maxLimit => isFromEntering ? _maxFromAssetVolume : _maxToAssetVolume;

  @computed
  int get maxWholePrartLenght => isBothAssetsSeted ? maxLimit.round().toString().length + 1 : 15;

  @computed
  bool get isBothAssetsSeted => fromAsset != null && toAsset != null;

  @action
  Future<void> loadLimits() async {
    if (fromAsset == null || toAsset == null) {
      return;
    }
    final model = SwapLimitsRequestModel(
      fromAsset: fromAsset?.symbol ?? '',
      toAsset: toAsset?.symbol ?? '',
    );
    try {
      final response = await sNetwork.getWalletModule().postSwapLimits(model);
      response.pick(
        onData: (data) {
          _minFromAssetVolume = data.minFromAssetVolume;
          _maxFromAssetVolume = data.maxFromAssetVolume;
          _minToAssetVolume = data.minToAssetVolume;
          _maxToAssetVolume = data.maxToAssetVolume;
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
      _validateInput();
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    }
  }

  @action
  void _validateInput() {
    if (Decimal.parse(primaryAmount) == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(primaryAmount)) {
      inputValid = false;

      return;
    }

    final value = Decimal.parse(primaryAmount);

    inputValid = value >= minLimit && value <= maxLimit;

    if (maxLimit == Decimal.zero) {
      _updatePaymentMethodInputError(
        null,
      );
    } else if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: minLimit,
          accuracy: primaryAccuracy,
          symbol: primarySymbol,
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: maxLimit,
          accuracy: primaryAccuracy,
          symbol: primarySymbol,
        )}',
      );
    } else {
      _updatePaymentMethodInputError(null);
    }

    const error = InputError.none;

    inputError = double.parse(primaryAmount) != 0
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
      sAnalytics.errorShowingErrorUnderConvertAmount(
        errorText: error,
      );
    }
    paymentMethodInputError = error;
  }
}
