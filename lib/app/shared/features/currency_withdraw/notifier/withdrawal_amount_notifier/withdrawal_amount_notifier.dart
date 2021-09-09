import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../components/balance_selector/model/selected_percent.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../withdrawal_address_notifier/withdrawal_address_notipod.dart';
import 'withdrawal_amount_state.dart';

/// Responsible for input and validation of the withdrawal amount
class WithdrawalAmountNotifier extends StateNotifier<WithdrawalAmountState> {
  WithdrawalAmountNotifier(
    this.read,
    this.currency,
  ) : super(const WithdrawalAmountState()) {
    final address = read(withdrawalAddressNotipod(currency));

    state = state.copyWith(
      tag: address.tag,
      address: address.address,
      baseCurrency: read(baseCurrencyPod),
    );
  }

  final Reader read;
  final CurrencyModel currency;

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

  void selectPercentFromBalance(SelectedPercent selected) {
    _logger.log(notifier, 'selectPercentFromBalance');

    final value = valueBasedOnSelectedPercent(
      selected: selected,
      currency: currency,
    );

    _updateAmount(
      valueAccordingToAccuracy(value, currency.accuracy),
    );
    _validateAmount();
    _calculateBaseConversion();
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
      _updateBaseConversionValue(zeroCase);
    }
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _validateAmount() {
    final error = inputError(state.amount, currency);
    
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
