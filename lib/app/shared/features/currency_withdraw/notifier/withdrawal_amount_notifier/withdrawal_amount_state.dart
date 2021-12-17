import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/input_helpers.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';

part 'withdrawal_amount_state.freezed.dart';

@freezed
class WithdrawalAmountState with _$WithdrawalAmountState {
  const factory WithdrawalAmountState({
    BaseCurrencyModel? baseCurrency,
    SKeyboardPreset? selectedPreset,
    @Default('') String tag,
    @Default('') String address,
    @Default('0') String amount,
    @Default('0') String baseConversionValue,
    @Default(false) bool valid,
    @Default(false) bool addressIsInternal,
    @Default(InputError.none) InputError inputError,
  }) = _WithdrawalAmountState;
}
