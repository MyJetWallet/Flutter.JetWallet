import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_confirm_state.freezed.dart';

@freezed
class WithdrawalConfirmState with _$WithdrawalConfirmState {
  const factory WithdrawalConfirmState({
    @Default(false) bool isResending,
  }) = _WithdrawalConfirmState;
}
