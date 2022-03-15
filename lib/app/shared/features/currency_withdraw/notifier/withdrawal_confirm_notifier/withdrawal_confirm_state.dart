import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'withdrawal_confirm_union.dart';

part 'withdrawal_confirm_state.freezed.dart';

@freezed
class WithdrawalConfirmState with _$WithdrawalConfirmState {
  const factory WithdrawalConfirmState({
    @Default(Input()) WithdrawalConfirmUnion union,
    @Default(false) bool isResending,
    required TextEditingController controller,
  }) = _WithdrawalConfirmState;
}
