import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/base_currencies_format.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
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
        assetSymbol: currency?.asset ?? 'BTC',
      );

  @observable
  PaymentMethodCategory category = PaymentMethodCategory.cards;

  @observable
  String inputValue = '0';
  @observable
  String targetConversionValue = '0';
  @observable
  String baseConversionValue = '0';

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
  ) {
    asset = inputAsset;
    currency = inputCurrency;
    method = inputMethod;
    card = inputCard;

    category =
        card == null ? inputMethod!.category! : PaymentMethodCategory.cards;

    updateLimitModel(inputCurrency);
    initPreset();
  }

  @action
  String conversionText(CurrencyModel currency) {
    final target = volumeFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: currency.symbol,
      prefix: currency.prefixSymbol,
      accuracy: currency.accuracy,
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
    return asset == null ? baseCurrency.accuracy : asset!.accuracy;
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
    preset1Name = method != null
        ? baseCurrenciesFormat(
            prefix: asset?.prefixSymbol ?? '',
            text: '50',
            symbol: asset?.symbol ?? '',
          )
        : '25%';
    preset2Name = method != null
        ? baseCurrenciesFormat(
            prefix: asset?.prefixSymbol ?? '',
            text: '100',
            symbol: asset?.symbol ?? '',
          )
        : '50%';
    preset3Name = method != null
        ? baseCurrenciesFormat(
            prefix: asset?.prefixSymbol ?? '',
            text: '500',
            symbol: asset?.symbol ?? '',
          )
        : 'MAX';
  }

  @action
  void tapPreset(String presetName) {
    tappedPreset = presetName;
  }

  @action
  void updateInputValue(String value) {
    inputValue = responseOnInputAction(
      oldInput: inputValue,
      newInput: value,
      accuracy: selectedCurrencyAccuracy,
    );

    print(inputValue);

    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  @action
  void _calculateTargetConversion() {}

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
  void selectFixedSum(SKeyboardPreset preset) {
    late int value;

    selectedPreset = preset;
    if (preset == SKeyboardPreset.preset1) {
      value = 50;
    } else if (preset == SKeyboardPreset.preset2) {
      value = 100;
    } else {
      value = 500;
    }

    inputValue = valueAccordingToAccuracy(value.toString(), 0);
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
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

      /*
      final value = double.parse(inputValue);
      var min = double.parse('${selectedPaymentAsset?.minAmount ?? 0}');
      var max = double.parse('${selectedPaymentAsset?.maxAmount ?? 0}');

      if (selectedPaymentMethod?.id == PaymentMethodType.circleCard ||
          selectedPaymentMethod?.id == PaymentMethodType.unlimintCard ||
          selectedPaymentMethod?.id == PaymentMethodType.simplex ||
          selectedPaymentMethod?.id == PaymentMethodType.bankCard) {
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
        if (selectedPaymentMethod?.id == PaymentMethodType.circleCard) {
          limitMax = pickedCircleCard?.paymentDetails.maxAmount.toDouble();
          min = pickedCircleCard?.paymentDetails.minAmount.toDouble() ?? 0;
          max = (limitMax ?? 0) <
                  (pickedCircleCard?.paymentDetails.maxAmount.toDouble() ?? 0)
              ? limitMax ?? 0
              : pickedCircleCard?.paymentDetails.maxAmount.toDouble() ?? 0;
        }
        if (selectedPaymentMethod?.id == PaymentMethodType.unlimintCard ||
            selectedPaymentMethod?.id == PaymentMethodType.simplex ||
            selectedPaymentMethod?.id == PaymentMethodType.bankCard) {
          max = (limitMax ?? 0) < max ? limitMax ?? 0 : max;
        }
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
            accuracy: paymentCurrency?.accuracy ?? baseCurrency!.accuracy,
            symbol: paymentCurrency?.symbol ?? baseCurrency!.symbol,
            prefix: paymentCurrency?.prefixSymbol ?? paymentCurrency?.symbol,
          )}',
        );
      } else if (value > max) {
        if (selectedPaymentMethod?.id == PaymentMethodType.circleCard &&
            pickedCircleCard == null) {
          return;
        }
        _updatePaymentMethodInputError(
          '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
            decimal: Decimal.parse(max.toString()),
            accuracy: paymentCurrency?.accuracy ?? baseCurrency!.accuracy,
            symbol: paymentCurrency?.symbol ?? baseCurrency!.symbol,
            prefix: paymentCurrency?.prefixSymbol ?? paymentCurrency?.symbol,
          )}',
        );
      } else {
        _updatePaymentMethodInputError(null);
      }
      */

      return;
    }

    _updatePaymentMethodInputError(null);

    if (asset == null) {
      inputValid = false;
    } else {
      final error = onTradeInputErrorHandler(
        inputValue,
        asset!,
      );

      inputValid = error == InputError.none ? isInputValid(inputValue) : false;
      inputError = error;
    }
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    paymentMethodInputError = error;
  }

  @action
  void _clearPercent() {
    tappedPreset = null;
    selectedPreset = null;
  }
}
