import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../components/balance_selector/model/selected_percent.dart';
import '../../../../components/number_keyboard/key_constants.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import 'send_amount_state.dart';

class SendAmountNotifier extends StateNotifier<SendAmountState> {
  SendAmountNotifier(
    this.read,
    this.withdrawal,
  ) : super(const SendAmountState()) {
    state = state.copyWith(
      baseCurrency: read(baseCurrencyPod),
    );

    currency = withdrawal.currency;
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late CurrencyModel currency;

  static final _logger = Logger('SendAmountNotifier');

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
      _updateBaseConversionValue(zero);
    }
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _validateAmount() {
    final error = inputError(
      state.amount,
      currency,
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
