import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_confirm_state.freezed.dart';

@freezed
class WithdrawalConfirmState with _$WithdrawalConfirmState {
  const factory WithdrawalConfirmState({
    @Default(false) bool isResending,
    @Default(false) bool isRequesting,
  }) = _WithdrawalConfirmState;
}
