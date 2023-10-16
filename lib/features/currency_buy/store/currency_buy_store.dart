// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/currency_buy/models/formatted_circle_card.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/is_card_expired.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/keyboards/constants.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/utils/constants.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simplex/simplex_payment_request_model.dart';

import '../../../core/router/app_router.dart';

part 'currency_buy_store.g.dart';

class CurrencyBuyStore extends _CurrencyBuyStoreBase with _$CurrencyBuyStore {
  CurrencyBuyStore(
    super.currencyModel,
    super.paymentMethod,
    super.circleCard,
    super.unlimintCard,
    super.bankCard,
    super.newBankCardId,
    super.showUaAlert,
  );

  static _CurrencyBuyStoreBase of(BuildContext context) =>
      Provider.of<CurrencyBuyStore>(context, listen: false);
}

abstract class _CurrencyBuyStoreBase with Store {
  _CurrencyBuyStoreBase(
    this.currencyModel,
    this.paymentMethod,
    this.circleCard,
    this.unlimintCard,
    this.bankCard,
    this.newBankCardId,
    this.showUaAlert,
  ) {
    lastUsedPaymentMethod = sSignalRModules.keyValue.lastUsedPaymentMethod;

    final uC = sSignalRModules.cards.cardInfos.where(
      (element) => element.integration == IntegrationType.unlimint,
    );

    final uAC = sSignalRModules.cards.cardInfos.where(
      (element) => element.integration == IntegrationType.unlimintAlt,
    );

    unlimintCards = ObservableList.of(uC);
    unlimintAltCards = ObservableList.of(uAC);

    _initCurrencies();
    _initBaseCurrency();
    _initCardLimit();
    Timer(
      const Duration(milliseconds: 500),
      () {
        if ((bankCard != null && bankCard!.showUaAlert) ||
            (unlimintCard != null && unlimintCard!.showUaAlert) ||
            (circleCard != null && circleCard!.showUaAlert) ||
            showUaAlert!) {
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
  }

  late final CurrencyModel currencyModel;
  late final PaymentMethodType paymentMethod;
  late final CircleCard? circleCard;
  late final CircleCard? unlimintCard;
  late final CircleCard? bankCard;
  late final String? newBankCardId;
  late final String? lastUsedPaymentMethod;
  late final bool? showUaAlert;

  static final _logger = Logger('CurrencyBuyStore');

  @observable
  bool disableSubmit = false;
  @action
  bool setDisableSubmit(bool value) => disableSubmit = value;

  @observable
  CardLimitsModel? cardLimit;

  @observable
  Decimal? targetConversionPrice;

  @observable
  BaseCurrencyModel? baseCurrency;

  @observable
  CircleCard? pickedCircleCard;

  @observable
  CircleCard? pickedUnlimintCard;

  @observable
  CircleCard? pickedAltUnlimintCard;

  @observable
  FormattedCircleCard? selectedCircleCard;

  @observable
  BuyMethodDto? selectedPaymentMethod;

  @observable
  PaymentAsset? selectedPaymentAsset;

  @observable
  CurrencyModel? paymentCurrency;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  CardLimitsModel? limitByAsset;

  @observable
  String? paymentMethodInputError;

  @observable
  RecurringBuysType recurringBuyType = RecurringBuysType.oneTimePurchase;

  @observable
  String inputValue = '0';

  @observable
  String targetConversionValue = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool inputValid = false;

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  ObservableList<CircleCard> circleCards = ObservableList.of([]);

  @observable
  ObservableList<CircleCard> unlimintCards = ObservableList.of([]);

  @observable
  ObservableList<CircleCard> unlimintAltCards = ObservableList.of([]);

  @observable
  InputError inputError = InputError.none;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @computed
  bool get isInputErrorActive {
    return inputError.isActive
        ? true
        : paymentMethodInputError != null
            ? true
            : false;
  }

  @computed
  String get inputErrorValue {
    return paymentMethodInputError != null
        ? paymentMethodInputError!
        : inputError.value();
  }

  @computed
  String get selectedCurrencySymbol {
    return paymentCurrency == null
        ? baseCurrency!.symbol
        : paymentCurrency!.symbol;
  }

  @computed
  int get selectedCurrencyAccuracy {
    return paymentCurrency == null
        ? baseCurrency!.accuracy
        : paymentCurrency!.accuracy;
  }

  @action
  String conversionText(CurrencyModel currency) {
    final target = volumeFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: currency.symbol,
      accuracy: currency.accuracy,
    );

    if (selectedPaymentMethod?.id == PaymentMethodType.simplex) {
      return '';
    }
    if (Decimal.parse(targetConversionValue) == Decimal.zero) {
      return target;
    }

    return '≈ $target';
  }

  @computed
  bool get isOneTimePurchaseOnly {
    final cond1 = selectedPaymentMethod?.id == PaymentMethodType.simplex;
    final cond2 = selectedPaymentMethod?.id == PaymentMethodType.circleCard;
    final cond3 = selectedPaymentMethod?.id == PaymentMethodType.unlimintCard;
    final cond4 = selectedPaymentMethod?.id == PaymentMethodType.bankCard;

    return cond1 || cond2 || cond3 || cond4;
  }

  @action
  void _initCurrencies() {
    final tempCurrencies = ObservableList.of(sSignalRModules.currenciesList);

    sortCurrencies(tempCurrencies);
    removeEmptyCurrenciesFrom(tempCurrencies);
    removeCurrencyFrom(tempCurrencies, currencyModel);
    currencies = tempCurrencies;
  }

  @action
  void _initBaseCurrency() {
    baseCurrency = sSignalRModules.baseCurrency;
  }

  @action
  void _initCardLimit() {
    final tempCardLimit = sSignalRModules.cardLimitsModel;

    cardLimit = tempCardLimit;
  }

  @action
  Future<void> _fetchCircleCards() async {
    if (currencyModel.supportsCircle) {
      loader.startLoadingImmediately();

      try {
        final response = await sNetwork.getWalletModule().getAllCards();

        response.pick(
          onData: (data) {
            final dataCards = data.cards.toList();

            dataCards.removeWhere(
              (card) {
                return isCardExpired(card.expMonth, card.expYear) ||
                    card.status == CircleCardStatus.failed;
              },
            );

            if (dataCards.isNotEmpty) {
              circleCards = ObservableList.of(dataCards);
            }
          },
        );
      } finally {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  Future<void> initDefaultPaymentMethod({required bool fromCard}) async {
    _logger.log(notifier, 'initDefaultPaymentMethod');

    await _fetchCircleCards();
    final isSimplexCanUse = currencyModel.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.simplex,
        )
        .toList();
    final isCircleCanUse = currencyModel.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.circleCard,
        )
        .toList();
    final isUnlimintCanUse = currencyModel.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.unlimintCard,
        )
        .toList();
    final isBankCardCanUse = currencyModel.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList();

    if (paymentMethod == PaymentMethodType.simplex &&
        isSimplexCanUse.isNotEmpty) {
      updateSelectedPaymentMethod(
        isSimplexCanUse[0],
      );
    } else if (paymentMethod == PaymentMethodType.circleCard &&
        isCircleCanUse.isNotEmpty) {
      if (circleCard != null) {
        updateSelectedCircleCard(
          circleCard!,
        );
      } else {
        updateSelectedPaymentMethod(
          isCircleCanUse[0],
        );
      }
    } else if (paymentMethod == PaymentMethodType.unlimintCard &&
        isUnlimintCanUse.isNotEmpty) {
      if (unlimintCard != null) {
        updateSelectedUnlimintCard(
          unlimintCard!,
        );
      } else {
        updateSelectedPaymentMethod(
          isUnlimintCanUse[0],
        );
      }
    } else if (paymentMethod == PaymentMethodType.bankCard &&
        isBankCardCanUse.isNotEmpty) {
      if (bankCard != null) {
        updateSelectedAltUnlimintCard(
          bankCard!,
        );
      } else if (newBankCardId != null) {
        final uAC = sSignalRModules.cards.cardInfos.where(
          (element) => element.integration == IntegrationType.unlimintAlt,
        );

        unlimintAltCards = ObservableList.of(uAC);
        final newCard = unlimintAltCards
            .where(
              (element) => element.id == newBankCardId,
            )
            .toList();
        if (newCard.isNotEmpty) {
          updateSelectedAltUnlimintCard(
            newCard[0],
          );
        } else {
          updateSelectedPaymentMethod(
            isBankCardCanUse[0],
          );
        }
      } else {
        updateSelectedPaymentMethod(
          isBankCardCanUse[0],
        );
      }
    }
    await initDefaultPaymentAsset();
  }

  @action
  Future<void> initDefaultPaymentAsset() async {
    final baseCurrencyInPayment = selectedPaymentMethod?.paymentAssets
        ?.where(
          (element) => element.asset == baseCurrency!.symbol,
        )
        .toList();
    selectedPaymentAsset =
        baseCurrencyInPayment != null && baseCurrencyInPayment.isNotEmpty
            ? baseCurrencyInPayment[0]
            : selectedPaymentMethod?.paymentAssets?[0];
    selectedPaymentAsset ??= PaymentAsset(
      asset: baseCurrency!.symbol,
      minAmount: Decimal.zero,
      maxAmount: Decimal.zero,
    );
    if (selectedPaymentAsset != null) {
      updateLimitModel(selectedPaymentAsset!);
      final currenciesPayment = sSignalRModules.currenciesWithHiddenList
          .where(
            (element) => element.symbol == selectedPaymentAsset!.asset,
          )
          .toList();
      if (currenciesPayment.isNotEmpty) {
        paymentCurrency = currenciesPayment[0];
      }
    }
  }

  @action
  void initRecurringBuyType(RecurringBuysType? type) {
    _logger.log(notifier, 'initRecurringBuyType');

    updateRecurringBuyType(type ?? RecurringBuysType.oneTimePurchase);
  }

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
  void updateSelectedPaymentMethod(
    BuyMethodDto? method, {
    bool isLocalUse = false,
  }) {
    _logger.log(notifier, 'updateSelectedPaymentMethod');

    selectedCurrency = null;
    selectedPaymentMethod = method;
    pickedUnlimintCard = isLocalUse ? pickedUnlimintCard : null;
    pickedAltUnlimintCard = isLocalUse ? pickedAltUnlimintCard : null;

    if (method?.id == PaymentMethodType.simplex ||
        method?.id == PaymentMethodType.circleCard ||
        method?.id == PaymentMethodType.unlimintCard ||
        method?.id == PaymentMethodType.bankCard) {
      updateRecurringBuyType(RecurringBuysType.oneTimePurchase);
    }
  }

  @action
  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    selectedCurrency = currency;
    selectedPaymentMethod = null;
  }

  @action
  void updatePaymentCurrency(PaymentAsset? asset) {
    _logger.log(notifier, 'updatePaymentCurrency');

    if (asset != selectedPaymentAsset) {
      selectedPaymentAsset = asset;
      if (selectedPaymentAsset != null) {
        updateLimitModel(selectedPaymentAsset!);
        final currenciesPayment = sSignalRModules.currenciesWithHiddenList
            .where(
              (element) => element.symbol == selectedPaymentAsset!.asset,
            )
            .toList();
        if (currenciesPayment.isNotEmpty) {
          paymentCurrency = currenciesPayment[0];
          _calculateTargetConversionForCrypto();
        }
      }
      if (inputValue == '0') {
        updateInputValue('0');
      } else {
        updateInputValue('');
      }
    }
  }

  @action
  void updateSelectedCircleCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedCircleCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.id == PaymentMethodType.circleCard;
    });

    pickedCircleCard = card;
    selectedCircleCard = formattedCircleCard(card, baseCurrency!);

    updateSelectedPaymentMethod(method.first);
  }

  @action
  void updateSelectedUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.id == PaymentMethodType.unlimintCard;
    });

    pickedUnlimintCard = card;

    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  @action
  void updateSelectedAltUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedAltUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.id == PaymentMethodType.bankCard;
    });

    pickedAltUnlimintCard = card;
    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  @action
  void updateRecurringBuyType(RecurringBuysType type) {
    _logger.log(notifier, 'updateRecurringBuyType');

    recurringBuyType = type;
  }

  @action
  void _updateInputValue(String value) {
    inputValue = value;
  }

  @action
  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');

    _updateInputValue(
      responseOnInputAction(
        oldInput: inputValue,
        newInput: value,
        accuracy: selectedCurrencyAccuracy,
      ),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  Future<void> setUpdateTargetConversionPrice(
    String symbol,
    String selectedCurrencySymbol,
  ) async {
    updateTargetConversionPrice(
      await getConversionPrice(
        ConversionPriceInput(
          baseAssetSymbol: symbol,
          quotedAssetSymbol: selectedCurrencySymbol,
        ),
      ),
    );
  }

  @action
  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    targetConversionPrice = price;
  }

  @action
  void _updateTargetConversionValue(String value) {
    targetConversionValue = value;
  }

  @action
  void _calculateTargetConversion() {
    if (selectedPaymentMethod?.id == PaymentMethodType.simplex) {
      _calculateTargetConversionForSimplex();
    } else {
      _calculateTargetConversionForCrypto();
    }
  }

  @action
  void _calculateTargetConversionForCrypto() {
    if (targetConversionPrice != null && inputValue.isNotEmpty) {
      final amount = Decimal.parse(inputValue);
      final price = targetConversionPrice!;
      final accuracy = currencyModel.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        conversion = (amount / price).toDecimal(
          scaleOnInfinitePrecision: accuracy,
        );
        if (baseCurrency != null && paymentCurrency != null) {
          if (baseCurrency!.symbol != paymentCurrency!.symbol) {
            conversion = Decimal.parse(
              (conversion * paymentCurrency!.currentPrice)
                  .toStringAsFixed(accuracy),
            );
          }
        }
      }

      _updateTargetConversionValue(
        truncateZerosFrom(
          conversion.toString(),
        ),
      );
    } else {
      _updateTargetConversionValue(zero);
    }
  }

  @action
  void _calculateTargetConversionForSimplex() {
    if (targetConversionPrice != null && inputValue.isNotEmpty) {
      final value = double.parse(inputValue);

      final sixPercent = value * 0.06;

      var recalculated = value;

      if (sixPercent <= 10) {
        recalculated = recalculated - 10;

        if (recalculated < 0) {
          recalculated = 0;
        }
      } else {
        recalculated = recalculated - sixPercent;
      }

      final amount = Decimal.parse(recalculated.toString());
      final price = targetConversionPrice!;
      final accuracy = currencyModel.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        conversion = (amount / price).toDecimal(
          scaleOnInfinitePrecision: accuracy,
        );
      }

      _updateTargetConversionValue(
        truncateZerosFrom(
          conversion.toString(),
        ),
      );
    } else {
      _updateTargetConversionValue(zero);
    }
  }

  @action
  void _updateBaseConversionValue(String value) {
    baseConversionValue = value;
  }

  @action
  void _calculateBaseConversion() {
    if (inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: selectedCurrencySymbol,
        assetBalance: Decimal.parse(inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  @action
  void _updateInputValid(bool value) {
    inputValid = value;
  }

  @action
  void _updateInputError(InputError error) {
    inputError = error;
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    if (error != null) {}
    paymentMethodInputError = error;
  }

  @action
  void _validateInput() {
    if (double.parse(inputValue) == 0.0) {
      _updateInputValid(true);
      _updateInputError(InputError.none);
      _updatePaymentMethodInputError(null);

      return;
    }
    if (selectedPaymentMethod != null) {
      if (!isInputValid(inputValue)) {
        _updateInputValid(false);

        return;
      }

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

      _updateInputValid(value >= min && value <= max);

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
          )}',
        );
      } else {
        _updatePaymentMethodInputError(null);
      }

      return;
    }

    _updatePaymentMethodInputError(null);

    if (selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      final error = onTradeInputErrorHandler(
        inputValue,
        selectedCurrency!,
      );

      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(inputValue),
        );
      } else {
        _updateInputValid(false);
      }

      _updateInputError(error);
    }
  }

  @action
  void resetValuesToZero() {
    _logger.log(notifier, 'resetValuesToZero');

    inputValue = zero;
    inputValue = zero;
    baseConversionValue = zero;
    inputValid = false;
    inputError = InputError.none;
    paymentMethodInputError = null;
  }

  @action
  Future<String?> makeSimplexRequest() async {
    _logger.log(notifier, 'makeSimplexRequest');

    final model = SimplexPaymentRequestModel(
      fromAmount: Decimal.parse(inputValue),
      fromCurrency: baseCurrency!.symbol,
      toAsset: currencyModel.symbol,
    );

    try {
      final response =
          await sNetwork.getWalletModule().postSimplexPayment(model);

      if (response.error != null) {
        _logger.log(stateFlow, 'makeSimplexRequest', response.error!.cause);

        sNotification.showError(
          response.error!.cause,
          id: 1,
        );

        return null;
      }

      return response.data?.paymentLink;
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'makeSimplexRequest', error.cause);

      sNotification.showError(
        error.cause,
        id: 1,
      );

      return null;
    } catch (e) {
      _logger.log(stateFlow, 'makeSimplexRequest', e);

      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );

      return null;
    }
  }

  @action
  Future<void> setLastUsedPaymentMethod() async {
    _logger.log(notifier, 'setLastUsedPaymentMethod');

    try {
      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: lastUsedPaymentMethodKey,
                  value: jsonEncode('simplex'),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'setLastUsedPaymentMethod', e);
    }
  }

  @action
  Future<void> onCircleCardAdded(CircleCard card) async {
    _logger.log(notifier, 'onCircleCardAdded');

    await _fetchCircleCards();
    updateSelectedCircleCard(card);
  }
}
