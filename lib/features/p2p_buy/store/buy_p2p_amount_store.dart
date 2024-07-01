import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/buy_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';

part 'buy_p2p_amount_store.g.dart';

class BuyP2PAmountStore extends _BuyP2PAmountStoreBase with _$BuyP2PAmountStore {
  BuyP2PAmountStore() : super();

  static BuyP2PAmountStore of(BuildContext context) => Provider.of<BuyP2PAmountStore>(context);
}

abstract class _BuyP2PAmountStoreBase with Store {
  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: fiatSymbol,
      );

  @computed
  bool get isContinueAvaible {
    return inputValid && Decimal.parse(primaryAmount) != Decimal.zero;
  }

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
    return paymentAsset?.asset ?? 'EUR';
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
  int get primaryAccuracy {
    return isFiatEntering ? buyCurrency.accuracy : asset?.accuracy ?? 2;
  }

  @computed
  int get secondaryAccuracy {
    return isFiatEntering ? asset?.accuracy ?? 2 : buyCurrency.accuracy;
  }

  @observable
  PaymentAsset? paymentAsset;

  @observable
  CurrencyModel? asset;

  @observable
  P2PMethodModel? p2pMethod;

  @action
  void init({
    CurrencyModel? inputAsset,
    PaymentAsset? inputPaymentAsset,
    P2PMethodModel? inputP2pMethod,
  }) {
    asset = inputAsset;
    paymentAsset = inputPaymentAsset;
    p2pMethod = inputP2pMethod;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    loadLimits();
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
    return 2;
  }

  @action
  void onBuyAll() {
    isFiatEntering = false;

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
        wholePartLenght: maxWholePrartLenght,
      );
    } else {
      cryptoInputValue = responseOnInputAction(
        oldInput: cryptoInputValue,
        newInput: value,
        accuracy: asset?.accuracy ?? 2,
        wholePartLenght: maxWholePrartLenght,
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
  void pasteValue(String value) {
    if (isFiatEntering) {
      fiatInputValue = value;
    } else {
      cryptoInputValue = value;
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

  @action
  void swapAssets() {
    isFiatEntering = !isFiatEntering;
    _cutUnnecessaryAccuracy();
    _validateInput();
  }

  @action
  void _cutUnnecessaryAccuracy() {
    if (isFiatEntering) {
      fiatInputValue = Decimal.parse(fiatInputValue).floor(scale: buyCurrency.accuracy).toString();
    } else {
      cryptoInputValue = Decimal.parse(cryptoInputValue).floor(scale: asset?.accuracy ?? 2).toString();
    }
  }

  @observable
  Decimal minSellAmount = Decimal.zero;

  @observable
  Decimal maxSellAmount = Decimal.zero;

  @observable
  Decimal minBuyAmount = Decimal.zero;

  @observable
  Decimal maxBuyAmount = Decimal.zero;

  @computed
  Decimal get minLimit => isFiatEntering ? minSellAmount : minBuyAmount;

  @computed
  Decimal get maxLimit => isFiatEntering ? maxSellAmount : maxBuyAmount;

  @computed
  int get maxWholePrartLenght => (maxLimit != Decimal.zero) ? maxLimit.round().toString().length + 1 : 15;

  @action
  Future<void> loadLimits() async {
    minSellAmount = Decimal.zero;
    maxSellAmount = Decimal.zero;
    minBuyAmount = Decimal.zero;
    maxBuyAmount = Decimal.zero;

    try {
      final model = BuyLimitsRequestModel(
        paymentAsset: fiatSymbol,
        buyAsset: asset?.symbol ?? '',
        paymentMethod: CirclePaymentMethod.paymeP2P,
        p2pReceiveMethodId: p2pMethod?.methodId,
      );
      final response = await sNetwork.getWalletModule().postBuyLimits(model);
      response.pick(
        onData: (data) {
          minSellAmount = data.minSellAmount;
          maxSellAmount = data.maxSellAmount;
          minBuyAmount = data.minBuyAmount;
          maxBuyAmount = data.maxBuyAmount;
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

    if (maxLimit == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

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

    inputError = double.parse(fiatInputValue) != 0
        ? error == InputError.none
            ? paymentMethodInputError == null
                ? InputError.none
                : InputError.limitError
            : error
        : InputError.none;
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    paymentMethodInputError = error;
  }
}
