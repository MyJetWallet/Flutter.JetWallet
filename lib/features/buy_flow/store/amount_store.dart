import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
part 'amount_store.g.dart';

class BuyAmountStore extends _BuyAmountStoreBase with _$BuyAmountStore {
  BuyAmountStore() : super();

  static BuyAmountStore of(BuildContext context) =>
      Provider.of<BuyAmountStore>(context, listen: false);
}

abstract class _BuyAmountStoreBase with Store {
  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: currency?.asset ?? 'BTC',
      );

  @observable
  PaymentMethodCategory category = PaymentMethodCategory.cards;

  @observable
  bool disableSubmit = false;
  @action
  bool setDisableSubmit(bool value) => disableSubmit = value;

  @observable
  String inputValue = '0';
  @observable
  String targetConversionValue = '0';
  @observable
  String baseConversionValue = '0';
  @observable
  Decimal? targetConversionPrice;

  @observable
  String? paymentMethodInputError;

  @observable
  CardLimitsModel? limitByAsset;

  @observable
  InputError inputError = InputError.none;

  @observable
  String preset1Name = '';
  @observable
  String preset2Name = '';
  @observable
  String preset3Name = '';

  @observable
  SKeyboardPreset? selectedPreset;
  @observable
  String? tappedPreset;
  @observable
  bool inputValid = false;

  @observable
  PaymentAsset? selectedPaymentAsset;

  CurrencyModel? asset;
  PaymentAsset? currency;
  BuyMethodDto? method;
  CircleCard? card;

  @action
  void init(
    CurrencyModel inputAsset,
    PaymentAsset inputCurrency,
    BuyMethodDto? inputMethod,
    CircleCard? inputCard,
    bool showUaAlert,
  ) {
    asset = inputAsset;
    currency = inputCurrency;
    method = inputMethod;
    card = inputCard;

    category =
        card == null ? inputMethod!.category! : PaymentMethodCategory.cards;

    updateLimitModel(inputCurrency);
    initPreset();

    loadConversionPrice(
      inputCurrency.asset,
      inputAsset.symbol,
    );

    selectedPaymentAsset = method!.paymentAssets!
        .firstWhere((element) => element.asset == currency?.asset);

    Timer(
      const Duration(milliseconds: 500),
      () {
        if ((inputCard != null && inputCard.showUaAlert) || showUaAlert) {
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
      paymentMethodName: category == PaymentMethodCategory.cards
          ? 'card'
          : inputMethod!.id.name,
      paymentMethodCurrency: buyCurrency.symbol,
    );
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

  @action
  String conversionText() {
    final target = volumeFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: asset?.symbol ?? '',
      prefix: asset?.prefixSymbol ?? '',
      accuracy: asset?.accuracy ?? 1,
    );

    if (Decimal.parse(targetConversionValue) == Decimal.zero) {
      return target;
    }

    return '≈ $target';
  }

  @computed
  String get inputErrorValue {
    return paymentMethodInputError != null
        ? paymentMethodInputError!
        : inputError.value();
  }

  @computed
  bool get isInputErrorActive {
    return inputError.isActive
        ? true
        : paymentMethodInputError != null
            ? true
            : false;
  }

  @computed
  int get selectedCurrencyAccuracy {
    return currency == null ? baseCurrency.accuracy : buyCurrency.accuracy;
  }

  @computed
  bool get isLimitBlock =>
      limitByAsset?.day1State == StateLimitType.block ||
      limitByAsset?.day7State == StateLimitType.block ||
      limitByAsset?.day30State == StateLimitType.block;

  @action
  void updateLimitModel(PaymentAsset asset) {
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
      var dayState = asset.limits!.dayValue == asset.limits!.dayLimit
          ? StateLimitType.block
          : StateLimitType.active;
      var weekState = asset.limits!.weekValue == asset.limits!.weekLimit
          ? StateLimitType.block
          : StateLimitType.active;
      var monthState = asset.limits!.monthValue == asset.limits!.monthLimit
          ? StateLimitType.block
          : StateLimitType.active;
      if (monthState == StateLimitType.block) {
        finalProgress = 100;
        finalInterval = StateBarType.day30;
        weekState = weekState == StateLimitType.block
            ? StateLimitType.block
            : StateLimitType.none;
        dayState = dayState == StateLimitType.block
            ? StateLimitType.block
            : StateLimitType.none;
      } else if (weekState == StateLimitType.block) {
        finalProgress = 100;
        finalInterval = StateBarType.day7;
        dayState = dayState == StateLimitType.block
            ? StateLimitType.block
            : StateLimitType.none;
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

  @action
  Future<void> initPreset() async {
    final presets = method!.paymentAssets!
        .firstWhere((element) => element.asset == currency?.asset)
        .presets!;

    preset1Name = formatPreset(presets.amount1 ?? Decimal.zero);
    preset2Name = formatPreset(presets.amount2 ?? Decimal.zero);
    preset3Name = formatPreset(presets.amount3 ?? Decimal.zero);
  }

  String getPresetName() {
    if (selectedPreset == SKeyboardPreset.preset1) {
      return preset1Name;
    } else if (selectedPreset == SKeyboardPreset.preset2) {
      return preset2Name;
    } else if (selectedPreset == SKeyboardPreset.preset3) {
      return preset3Name;
    } else {
      return 'false';
    }
  }

  String formatPreset(Decimal amount) {
    return amount >= Decimal.fromInt(10000)
        ? '${amount / Decimal.fromInt(1000)}k'
        : amount.toString();
  }

  @action
  void tapPreset(String presetName) {
    tappedPreset = presetName;
  }

  @action
  void setSelectedPreset(SKeyboardPreset preset) {
    selectedPreset = preset;
  }

  @action
  void selectFixedSum(SKeyboardPreset preset) {
    late String value;

    final presets = method!.paymentAssets!
        .firstWhere((element) => element.asset == currency?.asset)
        .presets!;

    if (preset == SKeyboardPreset.preset1) {
      value = presets.amount1!.toString();
    } else if (preset == SKeyboardPreset.preset2) {
      value = presets.amount2!.toString();
    } else {
      value = presets.amount3!.toString();
    }

    inputValue = valueAccordingToAccuracy(value, selectedCurrencyAccuracy);
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  void updateInputValue(String value) {
    inputValue = responseOnInputAction(
      oldInput: inputValue,
      newInput: value,
      accuracy: selectedCurrencyAccuracy,
    );

    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  @action
  void _calculateTargetConversion() {
    if (targetConversionPrice != null && inputValue.isNotEmpty) {
      final amount = Decimal.parse(inputValue);
      final price = targetConversionPrice!;
      final accuracy = asset!.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        conversion = Decimal.parse(
          (amount * price).toStringAsFixed(accuracy),
        );
      }

      targetConversionValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      targetConversionValue = zero;
    }
  }

  @action
  void _calculateBaseConversion() {
    if (inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: asset!.symbol,
        assetBalance: Decimal.parse(inputValue),
      );

      baseConversionValue = truncateZerosFrom(baseValue.toString());
    } else {
      baseConversionValue = zero;
    }
  }

  @action
  void _validateInput() {
    if (double.parse(inputValue) == 0.0) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }
    if (method != null) {
      if (!isInputValid(inputValue)) {
        inputValid = false;

        return;
      }
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'Buy Amount Store',
            message: selectedPaymentAsset.toString(),
          );

      final value = double.parse(inputValue);
      final min = double.parse('${selectedPaymentAsset?.minAmount ?? 0}');
      var max = double.parse('${selectedPaymentAsset?.maxAmount ?? 0}');

      if (category == PaymentMethodCategory.cards) {
        double? limitMax = max;

        if (limitByAsset != null) {
          limitMax = limitByAsset!.barInterval == StateBarType.day1
              ? (limitByAsset!.day1Limit - limitByAsset!.day1Amount).toDouble()
              : limitByAsset!.barInterval == StateBarType.day7
                  ? (limitByAsset!.day7Limit - limitByAsset!.day7Amount)
                      .toDouble()
                  : (limitByAsset!.day30Limit - limitByAsset!.day30Amount)
                      .toDouble();
        }

        max = limitMax < max ? limitMax : max;
      }

      inputValid = value >= min && value <= max;

      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'Buy Amount Store',
            message: 'min: $min, max: $max',
          );

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
    }

    const error = InputError.none;

    inputError = double.parse(inputValue) != 0
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
        paymentMethodName:
            category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
        paymentMethodCurrency: buyCurrency.symbol,
      );
    }
    paymentMethodInputError = error;
  }

  @action
  void _clearPercent() {
    tappedPreset = null;
    selectedPreset = null;
  }
}
