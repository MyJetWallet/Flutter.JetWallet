import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/services/key_value/model/key_value_request_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_response_model.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';
import 'package:simple_networking/services/signal_r/model/asset_payment_methods.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';
import 'package:simple_networking/services/simplex/model/simplex_payment_request_model.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/constants.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/currencies_helpers.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/is_card_expired.dart';
import '../../../../helpers/truncate_zeros_from.dart';
import '../../../../models/currency_model.dart';
import '../../../../models/selected_percent.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../card_limits/notifier/card_limits_notipod.dart';
import '../../../key_value/notifier/key_value_notipod.dart';
import '../../helper/formatted_circle_card.dart';
import 'currency_buy_state.dart';

class CurrencyBuyNotifier extends StateNotifier<CurrencyBuyState> {
  CurrencyBuyNotifier(
      this.read,
      this.currencyModel,
      this.lastUsedPaymentMethod,
      this.unlimintCards,
  )
      : super(CurrencyBuyState(loader: StackLoaderNotifier())) {
    _initCurrencies();
    _initBaseCurrency();
    _initCardLimit();
  }

  final Reader read;
  final CurrencyModel currencyModel;
  final String? lastUsedPaymentMethod;
  final List<CircleCard> unlimintCards;

  static final _logger = Logger('CurrencyBuyNotifier');

  void _initCurrencies() {
    final currencies = List<CurrencyModel>.from(read(currenciesPod));

    sortCurrencies(currencies);
    removeEmptyCurrenciesFrom(currencies);
    removeCurrencyFrom(currencies, currencyModel);
    state = state.copyWith(currencies: currencies);
  }

  void _initBaseCurrency() {
    state = state.copyWith(
      baseCurrency: read(baseCurrencyPod),
    );
  }

  void _initCardLimit() {
    state = state.copyWith(unlimintCards: unlimintCards);
    final cardLimit = read(cardLimitsNotipod);
    state = state.copyWith(
      cardLimit: cardLimit.cardLimits,
    );
  }

  Future<void> _fetchCircleCards() async {
    if (currencyModel.supportsCircle) {
      state.loader.startLoadingImmediately();

      try {
        final response = await read(circleServicePod).allCards();
        response.cards.removeWhere((card) {
          return isCardExpired(card.expMonth, card.expYear) ||
              card.status == CircleCardStatus.failed;
        });

        if (response.cards.isNotEmpty) {
          state = state.copyWith(circleCards: response.cards);
        }
      } finally {
        state.loader.finishLoadingImmediately();
      }
    }
  }

  Future<void> initDefaultPaymentMethod({required bool fromCard}) async {
    _logger.log(notifier, 'initDefaultPaymentMethod');

    await _fetchCircleCards();

    final cardPreferred = fromCard && currencyModel.supportsAtLeastOneBuyMethod;
    final buyMethods = currencyModel.buyMethods;

    if (state.currencies.isNotEmpty) {
      if (!cardPreferred) {
        // Case 1: If user has baseCurrency wallet with balance more than zero
        for (final currency in state.currencies) {
          if (currency.symbol == state.baseCurrency!.symbol) {
            return updateSelectedCurrency(currency);
          }
        }
      }

      if (!cardPreferred) {
        // Case 3: If the user has a crypt, then we choose the largest
        for (final currency in state.currencies) {
          if (currency.type != AssetType.fiat) {
            return updateSelectedCurrency(currency);
          }
        }
      }

      if (!cardPreferred) {
        // Case 2: If user has at least one fiat wallet
        for (final currency in state.currencies) {
          if (currency.type == AssetType.fiat) {
            return updateSelectedCurrency(currency);
          }
        }
      }


      if (lastUsedPaymentMethod == '"circleCard"' &&
          currencyModel.supportsCircle) {
        // Case 4: If user has at least one saved circle
        // card and use circle last time
        if (state.circleCards.isNotEmpty) {
          return updateSelectedCircleCard(state.circleCards.first);
        }
      }

      // Case 5: If asset supports only one Payment method
      if (currencyModel.supportsAtLeastOneBuyMethod &&
          currencyModel.buyMethods.length == 1) {
        if (currencyModel.buyMethods.first.type ==
            PaymentMethodType.circleCard) {
          if (state.circleCards.isNotEmpty) {
            return updateSelectedCircleCard(state.circleCards.first);
          }
        } else {
          return updateSelectedPaymentMethod(currencyModel.buyMethods.first);
        }
      }

      // Case 6: If asset supports more then one Payment method and use unlimint
      if (buyMethods.where((element) => element.type ==
          PaymentMethodType.unlimintCard,).isNotEmpty &&
          lastUsedPaymentMethod == '"unlimintCard"') {
        if (state.unlimintCards.isNotEmpty) {
          return updateSelectedUnlimintCard(state.unlimintCards[0]);
        }
        return updateSelectedPaymentMethod(buyMethods.where(
              (element) => element.type == PaymentMethodType.unlimintCard,
        ).first,);
      }

      // Case 7: If asset supports more then one Payment method and use simplex
      if (buyMethods.where((element) => element.type ==
          PaymentMethodType.simplex,).isNotEmpty &&
          lastUsedPaymentMethod == '"simplex"') {
        return updateSelectedPaymentMethod(buyMethods.where(
              (element) => element.type == PaymentMethodType.simplex,
        ).first,);
      }

      // Case 8: If user has at least one crypto wallet and haven't any
      // another buy method
      if (!currencyModel.supportsAtLeastOneBuyMethod) {
        return updateSelectedCurrency(state.currencies.first);
      }

      if (currencyModel.supportsCircle) {
        // Case 9: If user has at least one saved circle
        // card and haven't saved methods
        if (state.circleCards.isNotEmpty) {
          return updateSelectedCircleCard(state.circleCards.first);
        }
      }
    } else {
      if (lastUsedPaymentMethod == '"circleCard"' &&
          currencyModel.supportsCircle) {
        // Case 1: If user has at least one saved circle
        // card and use circle last time
        if (state.circleCards.isNotEmpty) {
          return updateSelectedCircleCard(state.circleCards.first);
        }
      }

      // Case 2: If asset supports only one Payment method
      if (currencyModel.supportsAtLeastOneBuyMethod &&
          currencyModel.buyMethods.length == 1) {
        if (currencyModel.buyMethods.first.type ==
            PaymentMethodType.circleCard) {
          if (state.circleCards.isNotEmpty) {
            return updateSelectedCircleCard(state.circleCards.first);
          }
        } else {
          return updateSelectedPaymentMethod(currencyModel.buyMethods.first);
        }
      }

      // Case 3: If asset supports more then one Payment method and use unlimint
      if (buyMethods.where((element) => element.type ==
          PaymentMethodType.unlimintCard,).isNotEmpty &&
          lastUsedPaymentMethod == '"unlimintCard"') {
        if (state.unlimintCards.isNotEmpty) {
          return updateSelectedUnlimintCard(state.unlimintCards[0]);
        }
        return updateSelectedPaymentMethod(buyMethods.where(
              (element) => element.type == PaymentMethodType.unlimintCard,
        ).first,);
      }

      // Case 4: If asset supports more then one Payment method and use simplex
      if (buyMethods.where((element) => element.type ==
          PaymentMethodType.simplex,).isNotEmpty &&
          lastUsedPaymentMethod == '"simplex"') {
        return updateSelectedPaymentMethod(buyMethods.where(
              (element) => element.type == PaymentMethodType.simplex,
        ).first,);
      }

      if (currencyModel.supportsCircle) {
        // Case 5: If user has at least one saved circle
        // card and haven't saved methods
        if (state.circleCards.isNotEmpty) {
          return updateSelectedCircleCard(state.circleCards.first);
        }
      }
    }
  }

  void initRecurringBuyType(RecurringBuysType? type) {
    _logger.log(notifier, 'initRecurringBuyType');

    updateRecurringBuyType(type ?? RecurringBuysType.oneTimePurchase);
  }

  void updateSelectedPaymentMethod(PaymentMethod? method,
      {
        bool isLocalUse = false,
      }) {
    _logger.log(notifier, 'updateSelectedPaymentMethod');

    state = state.copyWith(
      selectedCurrency: null,
      selectedPaymentMethod: method,
      pickedUnlimintCard: isLocalUse ? state.pickedUnlimintCard : null,
    );

    if (method?.type == PaymentMethodType.simplex ||
        method?.type == PaymentMethodType.circleCard ||
        method?.type == PaymentMethodType.unlimintCard) {
      updateRecurringBuyType(RecurringBuysType.oneTimePurchase);
    }
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(
      selectedCurrency: currency,
      selectedPaymentMethod: null,
    );
  }

  void updateSelectedCircleCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedCircleCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.type == PaymentMethodType.circleCard;
    });

    state = state.copyWith(
      pickedCircleCard: card,
      selectedCircleCard: formattedCircleCard(card, state.baseCurrency!),
    );
    updateSelectedPaymentMethod(method.first);
  }

  void updateSelectedUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.type == PaymentMethodType.unlimintCard;
    });

    state = state.copyWith(
      pickedUnlimintCard: card,
    );
    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  void tapPreset(String presetName) {
    state = state.copyWith(tappedPreset: presetName);
  }

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

  void updateRecurringBuyType(RecurringBuysType type) {
    _logger.log(notifier, 'updateRecurringBuyType');

    state = state.copyWith(recurringBuyType: type);
  }

  void selectPercentFromBalance(SKeyboardPreset preset) {
    if (state.selectedCurrency != null) {
      _logger.log(notifier, 'selectPercentFromBalance');

      _updateSelectedPreset(preset);

      final percent = _percentFromPreset(preset);

      final value = valueBasedOnSelectedPercent(
        selected: percent,
        currency: state.selectedCurrency!,
      );

      _updateInputValue(
        valueAccordingToAccuracy(value, state.selectedCurrency!.accuracy),
      );
      _validateInput();
      _calculateTargetConversion();
      _calculateBaseConversion();
    }
  }

  void _updateSelectedPreset(SKeyboardPreset preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
  }

  void _updateInputValue(String value) {
    state = state.copyWith(inputValue: value);
  }

  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');

    _updateInputValue(
      responseOnInputAction(
        oldInput: state.inputValue,
        newInput: value,
        accuracy: state.selectedCurrencyAccuracy,
      ),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    state = state.copyWith(targetConversionPrice: price);
  }

  void _updateTargetConversionValue(String value) {
    state = state.copyWith(targetConversionValue: value);
  }

  void _calculateTargetConversion() {
    if (state.selectedPaymentMethod?.type == PaymentMethodType.simplex) {
      _calculateTargetConversionForSimplex();
    } else {
      _calculateTargetConversionForCrypto();
    }
  }

  void _calculateTargetConversionForCrypto() {
    if (state.targetConversionPrice != null && state.inputValue.isNotEmpty) {
      final amount = Decimal.parse(state.inputValue);
      final price = state.targetConversionPrice!;
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

  void _calculateTargetConversionForSimplex() {
    if (state.targetConversionPrice != null && state.inputValue.isNotEmpty) {
      final value = double.parse(state.inputValue);

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
      final price = state.targetConversionPrice!;
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

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _calculateBaseConversion() {
    if (state.inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        read: read,
        assetSymbol: state.selectedCurrencySymbol,
        assetBalance: Decimal.parse(state.inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  void _updateInputValid(bool value) {
    state = state.copyWith(inputValid: value);
  }

  void _updateInputError(InputError error) {
    state = state.copyWith(inputError: error);
  }

  void _updatePaymentMethodInputError(String? error) {
    state = state.copyWith(paymentMethodInputError: error);
  }

  void _validateInput() {
    if (double.parse(state.inputValue) == 0.0) {
      _updateInputValid(true);
      _updateInputError(InputError.none);
      _updatePaymentMethodInputError(null);
      return;
    }
    if (state.selectedPaymentMethod != null) {
      if (!isInputValid(state.inputValue)) {
        _updateInputValid(false);
        return;
      }

      final value = double.parse(state.inputValue);
      var min = state.selectedPaymentMethod!.minAmount;
      var max = state.selectedPaymentMethod!.maxAmount;

      if (state.selectedPaymentMethod?.type == PaymentMethodType.circleCard ||
          state.selectedPaymentMethod?.type == PaymentMethodType.unlimintCard ||
          state.selectedPaymentMethod?.type == PaymentMethodType.simplex
      ) {
        double? limitMax = max;
        if (state.cardLimit != null) {
          limitMax = state.cardLimit!.barInterval == StateBarType.day1
              ? (state.cardLimit!.day1Limit - state.cardLimit!.day1Amount)
                .toDouble()
              : state.cardLimit!.barInterval == StateBarType.day7
              ? (state.cardLimit!.day7Limit - state.cardLimit!.day7Amount)
                .toDouble()
              : (state.cardLimit!.day30Limit - state.cardLimit!.day30Amount)
                .toDouble();
        }
        if (state.selectedPaymentMethod?.type == PaymentMethodType.circleCard) {
          limitMax = state.pickedCircleCard?.paymentDetails.maxAmount
              .toDouble();
          min = state.pickedCircleCard?.paymentDetails.minAmount.toDouble()
              ?? 0;
          max = (limitMax ?? 0) <
              (state.pickedCircleCard?.paymentDetails.maxAmount.toDouble()
                  ?? 0)
              ? limitMax ?? 0
              : state.pickedCircleCard?.paymentDetails.maxAmount.toDouble()
                ?? 0;
        }
        if (state.selectedPaymentMethod?.type ==
            PaymentMethodType.unlimintCard ||
            state.selectedPaymentMethod?.type == PaymentMethodType.simplex) {
          max = (limitMax ?? 0) < max ? limitMax ?? 0 : max;
        }
      }

      _updateInputValid(value >= min && value <= max);

      final intl = read(intlPod);

      if (value < min) {
        _updatePaymentMethodInputError(
          '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
            decimal: Decimal.parse(min.toString()),
            accuracy: state.baseCurrency!.accuracy,
            symbol: state.baseCurrency!.symbol,
            prefix: state.baseCurrency!.prefix,
          )}',
        );
      } else if (value > max) {
        if (state.selectedPaymentMethod?.type == PaymentMethodType.circleCard &&
            state.pickedCircleCard == null) {
          return;
        }
        _updatePaymentMethodInputError(
          '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
            decimal: Decimal.parse(max.toString()),
            accuracy: state.baseCurrency!.accuracy,
            symbol: state.baseCurrency!.symbol,
            prefix: state.baseCurrency!.prefix,
          )}',
        );
      } else {
        _updatePaymentMethodInputError(null);
      }

      return;
    }

    _updatePaymentMethodInputError(null);

    if (state.selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      final error = onTradeInputErrorHandler(
        state.inputValue,
        state.selectedCurrency!,
      );

      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(state.inputValue),
        );
      } else {
        _updateInputValid(false);
      }

      _updateInputError(error);
    }
  }

  void resetValuesToZero() {
    _logger.log(notifier, 'resetValuesToZero');

    state = state.copyWith(
      inputValue: zero,
      targetConversionValue: zero,
      baseConversionValue: zero,
      inputValid: false,
      inputError: InputError.none,
      paymentMethodInputError: null,
    );
  }

  Future<String?> makeSimplexRequest() async {
    _logger.log(notifier, 'makeSimplexRequest');

    final model = SimplexPaymentRequestModel(
      fromAmount: Decimal.parse(state.inputValue),
      fromCurrency: state.baseCurrency!.symbol,
      toAsset: currencyModel.symbol,
    );

    final intl = read(intlPod);

    try {
      final response = await read(simplexServicePod).payment(
        model,
        intl.localeName,
      );

      await setLastUsedPaymentMethod();
      return response.paymentLink;
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'makeSimplexRequest', error.cause);

      read(sNotificationNotipod.notifier).showError(
        error.cause,
        id: 1,
      );
    } catch (e) {
      _logger.log(stateFlow, 'makeSimplexRequest', e);

      final intl = read(intlPod);

      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong,
        id: 1,
      );
    }

    return null;
  }

  Future<void> setLastUsedPaymentMethod() async {
    _logger.log(notifier, 'setLastUsedPaymentMethod');

    try {
      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: lastUsedPaymentMethodKey,
              value: jsonEncode('simplex'),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'setLastUsedPaymentMethod', e);
    }
  }

  Future<void> onCircleCardAdded(CircleCard card) async {
    _logger.log(notifier, 'onCircleCardAdded');

    await _fetchCircleCards();
    updateSelectedCircleCard(card);
  }

  void _clearPercent() {
    state = state.copyWith(selectedPreset: null);
  }
}
