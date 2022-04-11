import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../../service/services/signal_r/model/asset_payment_methods.dart';
import '../../../../../../service/services/simplex/model/simplex_payment_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/currencies_helpers.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/truncate_zeros_from.dart';
import '../../../../models/currency_model.dart';
import '../../../../models/selected_percent.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import 'currency_buy_state.dart';

class CurrencyBuyNotifier extends StateNotifier<CurrencyBuyState> {
  CurrencyBuyNotifier(this.read, this.currencyModel)
      : super(const CurrencyBuyState()) {
    _initCurrencies();
    _initBaseCurrency();
  }

  final Reader read;
  final CurrencyModel currencyModel;

  static final _logger = Logger('CurrencyBuyNotifier');

  void _initCurrencies() {
    final currencies = List<CurrencyModel>.from(
      read(currenciesPod),
    );
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

  void initDefaultPaymentMethod({required bool fromCard}) {
    if (fromCard && currencyModel.supportsAtLeastOneBuyMethod) {
      final method = currencyModel.buyMethods.first;
      updateSelectedPaymentMethod(method);
      return;
    }

    if (state.currencies.isNotEmpty) {
      // Case 1: If use has baseCurrency wallet with balance more than zero
      for (final currency in state.currencies) {
        if (currency.symbol == state.baseCurrency!.symbol) {
          updateSelectedCurrency(currency);
          return;
        }
      }

      // Case 2: If user has at least one fiat wallet
      for (final currency in state.currencies) {
        if (currency.type == AssetType.fiat) {
          updateSelectedCurrency(currency);
          return;
        }
      }

      // TODO Case 3: If user has at least one saved card

      // TODO Case 4: Payment methods

      // Case 5: If user has at least one crypto wallet
      updateSelectedCurrency(state.currencies.first);
    }
  }

  void updateSelectedPaymentMethod(PaymentMethod? method) {
    _logger.log(notifier, 'updateSelectedPaymentMethod');

    state = state.copyWith(selectedCurrency: null);
    state = state.copyWith(selectedPaymentMethod: method);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedPaymentMethod: null);
    state = state.copyWith(selectedCurrency: currency);
  }

  void selectFixedSum(SKeyboardPreset preset) {
    late int value;

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
  }

  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    state = state.copyWith(targetConversionPrice: price);
  }

  void _updateTargetConversionValue(String value) {
    state = state.copyWith(targetConversionValue: value);
  }

  void _calculateTargetConversion() {
    if (state.selectedPaymentMethod != null) {
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
    if (state.selectedPaymentMethod != null) {
      if (!isInputValid(state.inputValue)) {
        _updateInputValid(false);
        return;
      }

      final value = double.parse(state.inputValue);
      final min = state.selectedPaymentMethod!.minAmount;
      final max = state.selectedPaymentMethod!.maxAmount;

      _updateInputValid(value >= min && value <= max);

      if (value < min) {
        _updatePaymentMethodInputError(
          'Enter a higher amount. Min ${volumeFormat(
            decimal: Decimal.parse(min.toString()),
            accuracy: state.baseCurrency!.accuracy,
            symbol: state.baseCurrency!.symbol,
            prefix: state.baseCurrency!.prefix,
          )}',
        );
      } else if (value > max) {
        _updatePaymentMethodInputError(
          'Enter smaller amount. Max ${volumeFormat(
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

    _updateInputValue(zero);
    _updateTargetConversionValue(zero);
    _updateBaseConversionValue(zero);
    _updateInputValid(false);
  }

  Future<String?> makeSimplexRequest() async {
    final model = SimplexPaymentRequestModel(
      fromAmount: Decimal.parse(state.inputValue),
      fromCurrency: state.baseCurrency!.symbol,
      toAsset: currencyModel.symbol,
    );

    try {
      final response = await read(simplexServicePod).payment(model);

      return response.paymentLink;
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'makeSimplexRequest', error.cause);

      read(sNotificationNotipod.notifier).showError(
        error.cause,
        id: 1,
      );
    } catch (e) {
      _logger.log(stateFlow, 'makeSimplexRequest', e);

      read(sNotificationNotipod.notifier).showError(
        'Something went wrong',
        id: 1,
      );
    }

    return null;
  }
}
