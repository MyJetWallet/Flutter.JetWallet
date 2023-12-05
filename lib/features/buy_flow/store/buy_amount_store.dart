import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
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
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/buy_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/swap_limits_request_model.dart';
part 'buy_amount_store.g.dart';

class BuyAmountStore extends _BuyAmountStoreBase with _$BuyAmountStore {
  BuyAmountStore() : super();

  static BuyAmountStore of(BuildContext context) => Provider.of<BuyAmountStore>(context, listen: false);
}

abstract class _BuyAmountStoreBase with Store {
  @computed
  PaymenthMethodType get pmType => card != null
      ? PaymenthMethodType.card
      : account?.isClearjuctionAccount ?? false
          ? PaymenthMethodType.cjAccount
          : PaymenthMethodType.unlimitAccount;

  @computed
  String get buyPM => card != null
      ? 'Saved card ${card?.last4}'
      : account?.isClearjuctionAccount ?? false
          ? 'CJ  ${account?.balance}'
          : 'Unlimint  ${account?.balance}';

  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: fiatSymbol,
      );

  @computed
  PaymentMethodCategory get category {
    if (card != null) {
      return PaymentMethodCategory.cards;
    } else if (account != null) {
      return PaymentMethodCategory.account;
    } else {
      return PaymentMethodCategory.none;
    }
  }

  @computed
  CirclePaymentMethod get circlePaymentMethod {
    return card != null ? CirclePaymentMethod.bankCard : CirclePaymentMethod.ibanTransferUnlimint;
  }

  @computed
  bool get isContinueAvaible {
    return inputValid &&
        Decimal.parse(primaryAmount) != Decimal.zero &&
        (account != null || card != null) &&
        asset != null;
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
  int get primaryAccuracy {
    return isFiatEntering ? buyCurrency.accuracy : asset?.accuracy ?? 2;
  }

  @computed
  int get secondaryAccuracy {
    return isFiatEntering ? asset?.accuracy ?? 2 : buyCurrency.accuracy;
  }

  @computed
  String get fiatBalance {
    return category == PaymentMethodCategory.cards ? card?.toString() ?? '' : account?.currency ?? '';
  }

  @observable
  PaymentAsset? paymentAsset;

  @observable
  CurrencyModel? asset;

  @observable
  CircleCard? card;

  @observable
  SimpleBankingAccount? account;

  @action
  void init({
    CurrencyModel? inputAsset,
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  }) {
    asset = inputAsset;
    card = inputCard;
    this.account = account;

    if (category == PaymentMethodCategory.cards) {
      paymentAsset = inputAsset?.buyMethods
          .firstWhere((element) => element.id == PaymentMethodType.bankCard)
          .paymentAssets
          ?.firstWhere((element) => element.asset == 'EUR');
    }

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    loadLimits();

    Timer(
      const Duration(milliseconds: 500),
      () {
        if (inputCard != null && inputCard.showUaAlert) {
          sAnalytics.unsupportedCurrencyPopupView();
          sShowAlertPopup(
            sRouter.navigatorKey.currentContext!,
            primaryText: intl.currencyBuy_alert,
            secondaryText: intl.currencyBuy_alertDescription,
            primaryButtonName: intl.actionBuy_gotIt,
            image: Image.asset(
              phoneChangeAsset,
              width: 80,
              height: 80,
              package: 'simple_kit',
            ),
            onPrimaryButtonTap: () {
              sAnalytics.tapOnTheGotItButtonOnUnsupportedCurrencyScreen();
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
          );
        }
      },
    );
  }

  @action
  void setNewAsset(CurrencyModel newAsset) {
    asset = newAsset;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    loadLimits();

    fiatInputValue = '0';

    cryptoInputValue = '0';
    errorText = null;

    inputValid = false;

    _validateInput();
  }

  @action
  void setNewPayWith({
    CircleCard? newCard,
    SimpleBankingAccount? newAccount,
  }) {
    if (newCard != null) {
      card = newCard;
      account = null;
      paymentAsset = asset?.buyMethods
          .firstWhere((element) => element.id == PaymentMethodType.bankCard)
          .paymentAssets
          ?.firstWhere((element) => element.asset == 'EUR');
    }
    if (newAccount != null) {
      account = newAccount;
      card = null;
      paymentAsset = null;
    }

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    loadLimits();

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
    if (account == null && card == null) {
      return;
    }
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
  Decimal _minSellAmount = Decimal.zero;

  @observable
  Decimal _maxSellAmount = Decimal.zero;

  @observable
  Decimal _minBuyAmount = Decimal.zero;

  @observable
  Decimal _maxBuyAmount = Decimal.zero;

  @computed
  Decimal get minLimit => isFiatEntering ? _minSellAmount : _minBuyAmount;

  @computed
  Decimal get maxLimit => isFiatEntering ? _maxSellAmount : _maxBuyAmount;

  @computed
  int get maxWholePrartLenght => isBothAssetsSeted ? maxLimit.round().toString().length + 1 : 15;

  @computed
  bool get isBothAssetsSeted => (account != null || card != null) && asset != null;

  @action
  Future<void> loadLimits() async {
    if (asset == null || (account == null && card == null)) {
      return;
    }

    try {
      if (account?.isClearjuctionAccount ?? false) {
        final model = SwapLimitsRequestModel(
          fromAsset: fiatSymbol,
          toAsset: asset?.symbol ?? '',
        );
        final response = await sNetwork.getWalletModule().postSwapLimits(model);
        response.pick(
          onData: (data) {
            _minSellAmount = data.minFromAssetVolume;
            _maxSellAmount = data.maxFromAssetVolume;
            _minBuyAmount = data.minToAssetVolume;
            _maxBuyAmount = data.maxToAssetVolume;
          },
          onError: (error) {
            sNotification.showError(
              error.cause,
              id: 1,
              needFeedback: true,
            );
          },
        );
      } else {
        final model = BuyLimitsRequestModel(
          paymentAsset: fiatSymbol,
          buyAsset: asset?.symbol ?? '',
          paymentMethod: circlePaymentMethod,
          bankingAccountId: account?.accountId ?? '',
        );
        final response = await sNetwork.getWalletModule().postBuyLimits(model);
        response.pick(
          onData: (data) {
            _minSellAmount = data.minSellAmount;
            _maxSellAmount = data.maxSellAmount;
            _minBuyAmount = data.minBuyAmount;
            _maxBuyAmount = data.maxBuyAmount;
          },
          onError: (error) {
            sNotification.showError(
              error.cause,
              id: 1,
              needFeedback: true,
            );
          },
        );
      }
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
