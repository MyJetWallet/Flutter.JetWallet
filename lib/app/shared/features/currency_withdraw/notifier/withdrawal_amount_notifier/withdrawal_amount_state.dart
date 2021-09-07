import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../helpers/input_helpers.dart';

part 'withdrawal_amount_state.freezed.dart';

@freezed
class WithdrawalAmountState with _$WithdrawalAmountState {
  const factory WithdrawalAmountState({
    @Default('') String tag,
    @Default('') String address,
    @Default('0') String amount,
    @Default(false) bool valid,
    @Default(InputError.none) InputError inputError,
  }) = _WithdrawalAmountState;
}
