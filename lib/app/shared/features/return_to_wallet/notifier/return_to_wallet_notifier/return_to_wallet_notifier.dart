import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/logging/levels.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/currencies_helpers.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/truncate_zeros_from.dart';
import '../../../../models/currency_model.dart';
import '../../../../models/selected_percent.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../model/return_to_wallet_input.dart';
import 'return_to_wallet_state.dart';

class ReturnToWalletNotifier extends StateNotifier<ReturnToWalletState> {
  ReturnToWalletNotifier(this.read, this.input)
      : super(const ReturnToWalletState()) {
    _initCurrencies();
    _initBaseCurrency();
    updateSelectedCurrency(input.currency);
    initBaseData();
  }

  final Reader read;
  final ReturnToWalletInput input;

  static final _logger = Logger('ReturnToWalletNotifier');

  void _initCurrencies() {
    final currencies = List<CurrencyModel>.from(
      read(currenciesPod),
    );
    sortCurrencies(currencies);
    removeCurrencyFrom(currencies, input.currency);
    state = state.copyWith(currencies: currencies);
  }

  void _initBaseCurrency() {
    state = state.copyWith(
      baseCurrency: read(baseCurrencyPod),
    );
  }

  Future<void> initBaseData() async {
    _logger.log(notifier, 'initBaseData');
    state = state.copyWith(
      offerId: input.earnOffer.offerId,
      amount: input.earnOffer.amount,
      apy: input.earnOffer.currentApy,
      currentApy: input.earnOffer.currentApy,
      currentBalance: input.earnOffer.amount,
    );
  }

  void tapPreset(String presetName) {
    state = state.copyWith(tappedPreset: presetName);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
    _validateInput();
  }

  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      availableBalance: state.currentBalance,
      selected: percent,
      currency: input.currency,
    );

    _updateInputValue(
      valueAccordingToAccuracy(value, input.currency.accuracy),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
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
        accuracy: input.currency.accuracy,
      ),
    );
    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    // needed to calculate conversion while switching between assets
    _calculateTargetConversion(price);
    state = state.copyWith(targetConversionPrice: price);
  }

  void _updateTargetConversionValue(String value) {
    state = state.copyWith(targetConversionValue: value);
  }

  void _calculateTargetConversion([Decimal? newPrice]) {
    if ((state.targetConversionPrice != null || newPrice != null) &&
        state.inputValue.isNotEmpty) {
      final amount = Decimal.parse(state.inputValue);
      final price = newPrice ?? state.targetConversionPrice!;
      final accuracy = state.selectedCurrencyAccuracy;

      final conversion = amount * price;

      _updateTargetConversionValue(
        truncateZerosFrom(
          conversion.toStringAsFixed(accuracy),
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
        assetSymbol: input.currency.symbol,
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

  void _validateInput() {
    final error = onTradeInputErrorHandler(
      state.inputValue,
      input.currency,
      availableBalance: state.currentBalance,
    );

    if (state.selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(state.inputValue),
        );
      } else {
        _updateInputValid(false);
      }
    }

    _updateInputError(error);
  }

  void _clearPercent() {
    state = state.copyWith(selectedPreset: null);
  }
}
