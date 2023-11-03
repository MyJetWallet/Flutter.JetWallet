import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
part 'sell_amount_store.g.dart';

class SellAmountStore extends _SellAmountStoreBase with _$SellAmountStore {
  SellAmountStore() : super();

  static SellAmountStore of(BuildContext context) => Provider.of<SellAmountStore>(context, listen: false);
}

abstract class _SellAmountStoreBase with Store {
  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: fiatSymbol,
      );

  @computed
  PaymentMethodCategory get category {
    return account != null ? PaymentMethodCategory.account : PaymentMethodCategory.none;
  }

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
  bool isFiatEntering = true;

  @observable
  String fiatInputValue = '0';

  @observable
  String cryptoInputValue = '0';

  @computed
  String get cryptoSymbol => asset?.symbol ?? '';

  @computed
  String get fiatSymbol {
    return 'EUR';
  }

  @computed
  String get primaryAmount {
    return isFiatEntering ? fiatInputValue : cryptoInputValue;
  }

  @computed
  String get primarySymbol {
    return isFiatEntering ? fiatSymbol : cryptoSymbol;
  }

  @computed
  String get secondaryAmount {
    return isFiatEntering ? cryptoInputValue : fiatInputValue;
  }

  @computed
  String get secondarySymbol {
    return isFiatEntering ? cryptoSymbol : fiatSymbol;
  }

  @computed
  String get fiatBalance {
    return account?.currency ?? '';
  }

  @computed
  Decimal get _availablePresentForProcessing => Decimal.one - ((convertMarkup / Decimal.parse('100')).toDecimal());

  @observable
  PaymentAsset? paymentAsset;

  @observable
  CurrencyModel? asset;

  @observable
  SimpleBankingAccount? account;

  @action
  void init({
    CurrencyModel? inputAsset,
  }) {
    asset = inputAsset;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    sAnalytics.newBuyBuyAssetView(
      asset: asset?.symbol ?? '',
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: buyCurrency.symbol,
    );
  }

  @action
  void setNewAsset(CurrencyModel newAsset) {
    asset = newAsset;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    fiatInputValue = '0';

    cryptoInputValue = '0';
    errorText = null;

    inputValid = false;
  }

  @action
  void setNewPayWith({
    SimpleBankingAccount? newAccount,
  }) {
    account = newAccount;
    paymentAsset = null;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    fiatInputValue = '0';

    cryptoInputValue = '0';
    errorText = null;
    _validateInput();
  }

  @action
  Future<void> loadConversionPrice(
    String baseS,
    String targetS,
  ) async {
    if (asset != null) {
      targetConversionPrice = await getConversionPrice(
        ConversionPriceInput(
          baseAssetSymbol: baseS,
          quotedAssetSymbol: targetS,
        ),
      );
    }
  }

  @action
  void onSwap() {
    isFiatEntering = isFiatEntering;
  }

  @computed
  String get inputErrorValue {
    return paymentMethodInputError != null ? paymentMethodInputError! : inputError.value();
  }

  @computed
  bool get isInputErrorActive {
    return inputError.isActive || paymentMethodInputError != null;
  }

  @computed
  int get fiatAccuracy {
    return sSignalRModules.currenciesList.firstWhere((element) => element.symbol == fiatSymbol).accuracy;
  }

  @action
  void onSellAll() {
    cryptoInputValue = responseOnInputAction(
      oldInput: cryptoInputValue,
      newInput: maxLimit.toString(),
      accuracy: asset?.accuracy ?? 2,
    );

    _calculateFiatConversion();

    _validateInput();
  }

  @action
  void updateInputValue(String value) {
    if (isFiatEntering) {
      fiatInputValue = responseOnInputAction(
        oldInput: fiatInputValue,
        newInput: value,
        accuracy: fiatAccuracy,
      );
    } else {
      cryptoInputValue = responseOnInputAction(
        oldInput: cryptoInputValue,
        newInput: value,
        accuracy: asset?.accuracy ?? 2,
      );
    }
    if (isFiatEntering) {
      _calculateCryptoConversion();
    } else {
      _calculateFiatConversion();
    }

    _validateInput();
  }

  @action
  void _calculateCryptoConversion() {
    if (targetConversionPrice != null && fiatInputValue != '0') {
      final amount = Decimal.parse(fiatInputValue);
      final price = targetConversionPrice!;
      final accuracy = asset!.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        conversion = Decimal.parse(
          (amount * price).toStringAsFixed(accuracy),
        );
      }

      cryptoInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      cryptoInputValue = zero;
    }
  }

  void _calculateFiatConversion() {
    if (targetConversionPrice != null && cryptoInputValue != '0') {
      final amount = Decimal.parse(cryptoInputValue);
      final price = targetConversionPrice!;
      final accuracy = asset!.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        final koef = amount.toDouble() / price.toDouble();
        conversion = Decimal.parse(
          koef.toStringAsFixed(accuracy),
        );
      }

      fiatInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      fiatInputValue = zero;
    }
  }

  @computed
  Decimal get minLimit {
    return asset?.minTradeAmount ?? Decimal.zero;
  }

  @computed
  Decimal get maxLimit {
    final assetBalance = asset?.assetBalance ?? Decimal.zero;
    final maxTradeAmount = asset?.maxTradeAmount ?? Decimal.zero;

    return (assetBalance < maxTradeAmount ? assetBalance : maxTradeAmount) * _availablePresentForProcessing;
  }

  @action
  void _validateInput() {
    if (Decimal.parse(cryptoInputValue) == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(cryptoInputValue)) {
      inputValid = false;

      return;
    }

    final value = Decimal.parse(cryptoInputValue);

    inputValid = value >= minLimit && value <= maxLimit;

    if (maxLimit == Decimal.zero) {
      _updatePaymentMethodInputError(
        intl.limitIsExceeded,
      );
    } else if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: minLimit,
          accuracy: asset?.accuracy ?? 2,
          symbol: asset?.symbol ?? '',
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: maxLimit,
          accuracy: asset?.accuracy ?? 2,
          symbol: asset?.symbol ?? '',
        )}',
      );
    } else {
      _updatePaymentMethodInputError(null);
    }

    const error = InputError.none;

    inputError = double.parse(cryptoInputValue) != 0
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
        asset: asset?.symbol ?? '',
        paymentMethodType: category.name,
        paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
        paymentMethodCurrency: buyCurrency.symbol,
      );
    }
    paymentMethodInputError = error;
  }
}
