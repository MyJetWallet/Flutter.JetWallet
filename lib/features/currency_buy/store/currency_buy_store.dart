// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
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
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/keyboards/constants.dart';
import 'package:simple_kit/modules/keyboards/simple_numeric_keyboard_amount.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simplex/simplex_payment_request_model.dart';

import '../../../utils/formatting/base/base_currencies_format.dart';

part 'currency_buy_store.g.dart';

class CurrencyBuyStore extends _CurrencyBuyStoreBase with _$CurrencyBuyStore {
  CurrencyBuyStore(
    CurrencyModel currencyModel,
    PaymentMethodType paymentMethod,
    CircleCard? circleCard,
    CircleCard? unlimintCard,
    CircleCard? bankCard,
    String? newBankCardId,
  ) : super(
    currencyModel,
    paymentMethod,
    circleCard,
    unlimintCard,
    bankCard,
    newBankCardId,
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
  }

  late final CurrencyModel currencyModel;
  late final PaymentMethodType paymentMethod;
  late final CircleCard? circleCard;
  late final CircleCard? unlimintCard;
  late final CircleCard? bankCard;
  late final String? newBankCardId;
  late final String? lastUsedPaymentMethod;

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
  PaymentMethod? selectedPaymentMethod;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  SKeyboardPreset? selectedPreset;

  @observable
  String? tappedPreset;

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
  String get preset1Name {
    return selectedPaymentMethod != null
        ? baseCurrenciesFormat(
            prefix: baseCurrency?.prefix ?? '',
            text: '50',
            symbol: baseCurrency?.symbol ?? '',
          )
        : '25%';
  }

  @computed
  String get preset2Name {
    return selectedPaymentMethod != null
        ? baseCurrenciesFormat(
            prefix: baseCurrency?.prefix ?? '',
            text: '100',
            symbol: baseCurrency?.symbol ?? '',
          )
        : '50%';
  }

  @computed
  String get preset3Name {
    return selectedPaymentMethod != null
        ? baseCurrenciesFormat(
            prefix: baseCurrency?.prefix ?? '',
            text: '500',
            symbol: baseCurrency?.symbol ?? '',
          )
        : 'MAX';
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
  String get inputErrorValue {
    return paymentMethodInputError != null
        ? paymentMethodInputError!
        : inputError.value();
  }

  @computed
  String get selectedCurrencySymbol {
    return selectedCurrency == null
        ? baseCurrency!.symbol
        : selectedCurrency!.symbol;
  }

  @computed
  int get selectedCurrencyAccuracy {
    return selectedCurrency == null
        ? baseCurrency!.accuracy
        : selectedCurrency!.accuracy;
  }

  @action
  String conversionText(CurrencyModel currency) {
    final target = volumeFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: currency.symbol,
      prefix: currency.prefixSymbol,
      accuracy: currency.accuracy,
    );

    final base = volumeFormat(
      accuracy: baseCurrency!.accuracy,
      prefix: baseCurrency!.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );

    if (selectedPaymentMethod?.type == PaymentMethodType.simplex) {
      return '';
    }

    if (selectedCurrency == null) {
      return '≈ $target';
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return '≈ $target';
    } else {
      return '≈ $target ($base)';
    }
  }

  @computed
  bool get isOneTimePurchaseOnly {
    final cond1 = selectedPaymentMethod?.type == PaymentMethodType.simplex;
    final cond2 = selectedPaymentMethod?.type == PaymentMethodType.circleCard;
    final cond3 = selectedPaymentMethod?.type == PaymentMethodType.unlimintCard;
    final cond4 = selectedPaymentMethod?.type == PaymentMethodType.bankCard;

    return cond1 || cond2 || cond3 || cond4;
  }

  @action
  void _initCurrencies() {
    final _currencies = ObservableList.of(sSignalRModules.currenciesList);

    sortCurrencies(_currencies);
    removeEmptyCurrenciesFrom(_currencies);
    removeCurrencyFrom(_currencies, currencyModel);
    currencies = _currencies;
  }

  @action
  void _initBaseCurrency() {
    baseCurrency = sSignalRModules.baseCurrency;
  }

  @action
  void _initCardLimit() {
    final _cardLimit = sSignalRModules.cardLimitsModel;

    cardLimit = _cardLimit;
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

              print(circleCards);
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
    final isSimplexCanUse = currencyModel.buyMethods.where(
          (element) => element.type == PaymentMethodType.simplex,
    ).toList();
    final isCircleCanUse = currencyModel.buyMethods.where(
          (element) => element.type == PaymentMethodType.simplex,
    ).toList();
    final isUnlimintCanUse = currencyModel.buyMethods.where(
          (element) => element.type == PaymentMethodType.simplex,
    ).toList();
    final isBankCardCanUse = currencyModel.buyMethods.where(
          (element) => element.type == PaymentMethodType.simplex,
    ).toList();

    if (
      paymentMethod == PaymentMethodType.simplex && isSimplexCanUse.isNotEmpty
    ) {
      updateSelectedPaymentMethod(
        isSimplexCanUse[0],
      );
    } else if (
      paymentMethod == PaymentMethodType.circleCard && isCircleCanUse.isNotEmpty
    ) {
      if (circleCard != null) {
        updateSelectedCircleCard(
          circleCard!,
        );
      } else {
        updateSelectedPaymentMethod(
          isCircleCanUse[0],
        );
      }
    } else if (
      paymentMethod == PaymentMethodType.unlimintCard &&
      isUnlimintCanUse.isNotEmpty
    ) {
      if (unlimintCard != null) {
        updateSelectedUnlimintCard(
          unlimintCard!,
        );
      } else {
        updateSelectedPaymentMethod(
          isUnlimintCanUse[0],
        );
      }
    } else if (
      paymentMethod == PaymentMethodType.bankCard && isBankCardCanUse.isNotEmpty
    ) {
      if (bankCard != null) {
        updateSelectedAltUnlimintCard(
          bankCard!,
        );
      } else if (newBankCardId != null) {
        final newCard = unlimintAltCards.where(
          (element) => element.id == newBankCardId,
        ).toList();
        if (newCard.isNotEmpty) {
          updateSelectedAltUnlimintCard(
            newCard[0],
          );
        }
      } else {
        updateSelectedPaymentMethod(
          isBankCardCanUse[0],
        );
      }
    }
  }

  @action
  void initRecurringBuyType(RecurringBuysType? type) {
    _logger.log(notifier, 'initRecurringBuyType');

    updateRecurringBuyType(type ?? RecurringBuysType.oneTimePurchase);
  }

  @action
  void updateSelectedPaymentMethod(
    PaymentMethod? method, {
    bool isLocalUse = false,
  }) {
    _logger.log(notifier, 'updateSelectedPaymentMethod');

    selectedCurrency = null;
    selectedPaymentMethod = method;
    pickedUnlimintCard = isLocalUse ? pickedUnlimintCard : null;
    pickedAltUnlimintCard = isLocalUse ? pickedAltUnlimintCard : null;

    if (method?.type == PaymentMethodType.simplex ||
        method?.type == PaymentMethodType.circleCard ||
        method?.type == PaymentMethodType.unlimintCard ||
        method?.type == PaymentMethodType.bankCard) {
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
  void updateSelectedCircleCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedCircleCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.type == PaymentMethodType.circleCard;
    });

    pickedCircleCard = card;
    selectedCircleCard = formattedCircleCard(card, baseCurrency!);

    updateSelectedPaymentMethod(method.first);
  }

  @action
  void updateSelectedUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.type == PaymentMethodType.unlimintCard;
    });

    pickedUnlimintCard = card;

    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  @action
  void updateSelectedAltUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedAltUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.type == PaymentMethodType.bankCard;
    });

    pickedAltUnlimintCard = card;
    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  @action
  void tapPreset(String presetName) {
    tappedPreset = presetName;
  }

  @action
  void selectFixedSum(SKeyboardPreset preset) {
    late int value;

    _updateSelectedPreset(preset);

    if (preset == SKeyboardPreset.preset1) {
      value = 50;
    } else if (preset == SKeyboardPreset.preset2) {
      value = 100;
    } else {
      value = 500;
    }

    _updateInputValue(
      valueAccordingToAccuracy(value.toString(), 0),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  void updateRecurringBuyType(RecurringBuysType type) {
    _logger.log(notifier, 'updateRecurringBuyType');

    recurringBuyType = type;
  }

  @action
  void selectPercentFromBalance(SKeyboardPreset preset) {
    if (selectedCurrency != null) {
      _logger.log(notifier, 'selectPercentFromBalance');

      _updateSelectedPreset(preset);

      final percent = _percentFromPreset(preset);

      final value = valueBasedOnSelectedPercent(
        selected: percent,
        currency: selectedCurrency!,
      );

      _updateInputValue(
        valueAccordingToAccuracy(value, selectedCurrency!.accuracy),
      );
      _validateInput();
      _calculateTargetConversion();
      _calculateBaseConversion();
    }
  }

  @action
  void _updateSelectedPreset(SKeyboardPreset preset) {
    selectedPreset = preset;
  }

  @action
  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
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
    _clearPercent();
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
    if (selectedPaymentMethod?.type == PaymentMethodType.simplex) {
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
      var min = selectedPaymentMethod!.minAmount;
      var max = selectedPaymentMethod!.maxAmount;

      if (selectedPaymentMethod?.type == PaymentMethodType.circleCard ||
          selectedPaymentMethod?.type == PaymentMethodType.unlimintCard ||
          selectedPaymentMethod?.type == PaymentMethodType.simplex ||
          selectedPaymentMethod?.type == PaymentMethodType.bankCard) {
        double? limitMax = max;

        if (cardLimit != null) {
          limitMax = cardLimit!.barInterval == StateBarType.day1
              ? (cardLimit!.day1Limit - cardLimit!.day1Amount).toDouble()
              : cardLimit!.barInterval == StateBarType.day7
                  ? (cardLimit!.day7Limit - cardLimit!.day7Amount).toDouble()
                  : (cardLimit!.day30Limit - cardLimit!.day30Amount).toDouble();
        }
        if (selectedPaymentMethod?.type == PaymentMethodType.circleCard) {
          limitMax = pickedCircleCard?.paymentDetails.maxAmount.toDouble();
          min = pickedCircleCard?.paymentDetails.minAmount.toDouble() ?? 0;
          max = (limitMax ?? 0) <
                  (pickedCircleCard?.paymentDetails.maxAmount.toDouble() ?? 0)
              ? limitMax ?? 0
              : pickedCircleCard?.paymentDetails.maxAmount.toDouble() ?? 0;
        }
        if (selectedPaymentMethod?.type == PaymentMethodType.unlimintCard ||
            selectedPaymentMethod?.type == PaymentMethodType.simplex ||
            selectedPaymentMethod?.type == PaymentMethodType.bankCard) {
          max = (limitMax ?? 0) < max ? limitMax ?? 0 : max;
        }
      }

      _updateInputValid(value >= min && value <= max);

      if (value < min) {
        _updatePaymentMethodInputError(
          '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
            decimal: Decimal.parse(min.toString()),
            accuracy: baseCurrency!.accuracy,
            symbol: baseCurrency!.symbol,
            prefix: baseCurrency!.prefix,
          )}',
        );
      } else if (value > max) {
        if (selectedPaymentMethod?.type == PaymentMethodType.circleCard &&
            pickedCircleCard == null) {
          return;
        }
        _updatePaymentMethodInputError(
          '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
            decimal: Decimal.parse(max.toString()),
            accuracy: baseCurrency!.accuracy,
            symbol: baseCurrency!.symbol,
            prefix: baseCurrency!.prefix,
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

  @action
  void _clearPercent() {
    selectedPreset = null;
  }
}
