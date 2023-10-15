import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
part 'amount_store.g.dart';

class BuyAmountStore extends _BuyAmountStoreBase with _$BuyAmountStore {
  BuyAmountStore() : super();

  static BuyAmountStore of(BuildContext context) => Provider.of<BuyAmountStore>(context, listen: false);
}

abstract class _BuyAmountStoreBase with Store {
  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: fiatSymbol,
      );

  @observable
  PaymentMethodCategory category = PaymentMethodCategory.cards;

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
    return category == PaymentMethodCategory.cards ? card?.cardAssetSymbol ?? '' : account?.currency ?? '';
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
    return category == PaymentMethodCategory.cards ? card?.toString() ?? '' : account?.currency ?? '';
  }

  @observable
  CardLimitsModel? limitByAsset;

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
    required CurrencyModel inputAsset,
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  }) {
    asset = inputAsset;
    card = inputCard;
    this.account = account;

    category = inputCard != null ? PaymentMethodCategory.cards : PaymentMethodCategory.account;

    if (category == PaymentMethodCategory.cards) {
      paymentAsset = inputAsset.buyMethods
          .firstWhere((element) => element.id == PaymentMethodType.bankCard)
          .paymentAssets
          ?.firstWhere((element) => element.asset == inputCard?.cardAssetSymbol);

      _updateLimitModel(paymentAsset!);
    }

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    Timer(
      const Duration(milliseconds: 500),
      () {
        if (inputCard != null && inputCard.showUaAlert) {
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
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
          );
        }
      },
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
    inputValid = false;
  }

  void setNewPayWith({
    CircleCard? newCard,
    SimpleBankingAccount? newAccount,
  }) {
    if (newCard != null) {
      card = newCard;
      account = null;
      category = PaymentMethodCategory.cards;
      paymentAsset = asset?.buyMethods
          .firstWhere((element) => element.id == PaymentMethodType.bankCard)
          .paymentAssets
          ?.firstWhere((element) => element.asset == newCard.cardAssetSymbol);

      _updateLimitModel(paymentAsset!);
    }
    if (newAccount != null) {
      account = newAccount;
      card = null;
      category = PaymentMethodCategory.account;
    }

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    fiatInputValue = '0';

    cryptoInputValue = '0';
    _validateInput();
  }

  @action
  Future<void> loadConversionPrice(
    String baseS,
    String targetS,
  ) async {
    targetConversionPrice = await getConversionPrice(
      ConversionPriceInput(
        baseAssetSymbol: baseS,
        quotedAssetSymbol: targetS,
      ),
    );
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
  int get selectedCurrencyAccuracy {
    return asset == null ? baseCurrency.accuracy : buyCurrency.accuracy;
  }

  @action
  void updateInputValue(String value) {
    if (isFiatEntering) {
      fiatInputValue = responseOnInputAction(
        oldInput: fiatInputValue,
        newInput: value,
        accuracy: selectedCurrencyAccuracy,
      );
    } else {
      cryptoInputValue = responseOnInputAction(
        oldInput: cryptoInputValue,
        newInput: value,
        accuracy: selectedCurrencyAccuracy,
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
  void _validateInput() {
    if (category == PaymentMethodCategory.account) {
      _validateInputAccaunt();
    } else {
      _validateInputCard();
    }
  }

  @action
  void _validateInputAccaunt() {
    if (account!.balance! < Decimal.parse(fiatInputValue)) {
      _updatePaymentMethodInputError('Not enough balance to proceed with the transaction');
      inputValid = false;
      inputError = InputError.amountTooLarge;

      return;
    }
    if (account!.balance! >= Decimal.parse(fiatInputValue)) {
      _updatePaymentMethodInputError(null);
      inputValid = true;
      inputError = InputError.none;

      return;
    }
    if (double.parse(fiatInputValue) == 0.0) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }
  }

  @action
  void _validateInputCard() {
    if (double.parse(fiatInputValue) == 0.0) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(fiatInputValue)) {
      inputValid = false;

      return;
    }

    final value = double.parse(fiatInputValue);
    final min = double.parse('${paymentAsset?.minAmount ?? 0}');
    var max = double.parse('${paymentAsset?.maxAmount ?? 0}');

    if (category == PaymentMethodCategory.cards) {
      double? limitMax = max;

      if (limitByAsset != null) {
        limitMax = limitByAsset!.barInterval == StateBarType.day1
            ? (limitByAsset!.day1Limit - limitByAsset!.day1Amount).toDouble()
            : limitByAsset!.barInterval == StateBarType.day7
                ? (limitByAsset!.day7Limit - limitByAsset!.day7Amount).toDouble()
                : (limitByAsset!.day30Limit - limitByAsset!.day30Amount).toDouble();
      }

      max = limitMax < max ? limitMax : max;
    }

    inputValid = value >= min && value <= max;

    if (max == 0) {
      _updatePaymentMethodInputError(
        intl.limitIsExceeded,
      );
    } else if (value < min) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: Decimal.parse(min.toString()),
          accuracy: buyCurrency.accuracy,
          symbol: buyCurrency.symbol,
        )}',
      );
    } else if (value > max) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: Decimal.parse(max.toString()),
          accuracy: buyCurrency.accuracy,
          symbol: buyCurrency.symbol,
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

  @action
  void _updateLimitModel(PaymentAsset asset) {
    int calcPercentage(Decimal first, Decimal second) {
      if (first == Decimal.zero) {
        return 0;
      }
      final doubleFirst = double.parse('$first');
      final doubleSecond = double.parse('$second');
      final doubleFinal = double.parse('${doubleFirst / doubleSecond}');

      return (doubleFinal * 100).round();
    }

    if (asset.limits != null) {
      var finalInterval = StateBarType.day1;
      var finalProgress = 0;
      var dayState = asset.limits!.dayValue == asset.limits!.dayLimit ? StateLimitType.block : StateLimitType.active;
      var weekState = asset.limits!.weekValue == asset.limits!.weekLimit ? StateLimitType.block : StateLimitType.active;
      var monthState =
          asset.limits!.monthValue == asset.limits!.monthLimit ? StateLimitType.block : StateLimitType.active;
      if (monthState == StateLimitType.block) {
        finalProgress = 100;
        finalInterval = StateBarType.day30;
        weekState = weekState == StateLimitType.block ? StateLimitType.block : StateLimitType.none;
        dayState = dayState == StateLimitType.block ? StateLimitType.block : StateLimitType.none;
      } else if (weekState == StateLimitType.block) {
        finalProgress = 100;
        finalInterval = StateBarType.day7;
        dayState = dayState == StateLimitType.block ? StateLimitType.block : StateLimitType.none;
        monthState = StateLimitType.none;
      } else if (dayState == StateLimitType.block) {
        finalProgress = 100;
        finalInterval = StateBarType.day1;
        weekState = StateLimitType.none;
        monthState = StateLimitType.none;
      } else {
        final dayLeft = asset.limits!.dayLimit - asset.limits!.dayValue;
        final weekLeft = asset.limits!.weekLimit - asset.limits!.weekValue;
        final monthLeft = asset.limits!.monthLimit - asset.limits!.monthValue;
        if (dayLeft <= weekLeft && dayLeft <= monthLeft) {
          finalInterval = StateBarType.day1;
          finalProgress = calcPercentage(
            asset.limits!.dayValue,
            asset.limits!.dayLimit,
          );
          dayState = StateLimitType.active;
          weekState = StateLimitType.none;
          monthState = StateLimitType.none;
        } else if (weekLeft <= monthLeft) {
          finalInterval = StateBarType.day7;
          finalProgress = calcPercentage(
            asset.limits!.weekValue,
            asset.limits!.weekLimit,
          );
          dayState = StateLimitType.none;
          weekState = StateLimitType.active;
          monthState = StateLimitType.none;
        } else {
          finalInterval = StateBarType.day30;
          finalProgress = calcPercentage(
            asset.limits!.monthValue,
            asset.limits!.monthLimit,
          );
          dayState = StateLimitType.none;
          weekState = StateLimitType.none;
          monthState = StateLimitType.active;
        }
      }

      final limitModel = CardLimitsModel(
        minAmount: asset.minAmount,
        maxAmount: asset.maxAmount,
        day1Amount: asset.limits!.dayValue,
        day1Limit: asset.limits!.dayLimit,
        day1State: dayState,
        day7Amount: asset.limits!.weekValue,
        day7Limit: asset.limits!.weekLimit,
        day7State: weekState,
        day30Amount: asset.limits!.monthValue,
        day30Limit: asset.limits!.monthLimit,
        day30State: monthState,
        barInterval: finalInterval,
        barProgress: finalProgress,
        leftHours: 0,
      );
      limitByAsset = limitModel;
    }
  }
}
