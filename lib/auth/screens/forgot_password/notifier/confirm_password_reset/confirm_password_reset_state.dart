import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'confirm_password_reset_union.dart';

part 'confirm_password_reset_state.freezed.dart';

@freezed
class ConfirmPasswordResetState with _$ConfirmPasswordResetState {
  const factory ConfirmPasswordResetState({
    @Default(Input()) ConfirmPasswordResetUnion union,
    required TextEditingController controller,
    @Default(false) bool isResending,
  }) = _ConfirmPasswordResetState;
}
