import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../models/selected_percent.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../model/withdrawal_model.dart';
import '../withdrawal_address_notifier/withdrawal_address_notipod.dart';
import 'withdrawal_amount_state.dart';

/// Responsible for input and validation of the withdrawal amount
class WithdrawalAmountNotifier extends StateNotifier<WithdrawalAmountState> {
  WithdrawalAmountNotifier(
    this.read,
    this.withdrawal,
  ) : super(const WithdrawalAmountState()) {
    final address = read(withdrawalAddressNotipod(withdrawal));

    state = state.copyWith(
      tag: address.tag,
      address: address.address,
      addressIsInternal: address.addressIsInternal,
      baseCurrency: read(baseCurrencyPod),
    );

    currency = withdrawal.currency;
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late CurrencyModel currency;

  static final _logger = Logger('WithdrawalAmountNotifier');

  void updateAmount(String value) {
    _logger.log(notifier, 'updateAmount');

    _updateAmount(
      responseOnInputAction(
        oldInput: state.amount,
        newInput: value,
        accuracy: currency.accuracy,
      ),
    );
    _validateAmount();
    _calculateBaseConversion();
  }

  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      selected: percent,
      currency: currency,
    );

    _updateAmount(
      valueAccordingToAccuracy(value, currency.accuracy),
    );
    _validateAmount();
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

  void _calculateBaseConversion() {
    if (state.amount.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        read: read,
        assetSymbol: currency.symbol,
        assetBalance: double.parse(state.amount),
      );

      _updateBaseConversionValue(
        truncateZerosFromInput(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _validateAmount() {
    final error = onWithdrawInputErrorHandler(
      state.amount,
      currency,
      addressIsInternal: state.addressIsInternal,
    );

    if (error == InputError.none) {
      _updateValid(
        isInputValid(state.amount),
      );
    } else {
      _updateValid(false);
    }

    _updateInputError(error);
  }

  void _updateAmount(String value) {
    state = state.copyWith(amount: value);
  }

  void _updateInputError(InputError error) {
    state = state.copyWith(inputError: error);
  }

  void _updateValid(bool value) {
    state = state.copyWith(valid: value);
  }
}
