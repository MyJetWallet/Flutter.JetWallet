import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_password_reset_state.freezed.dart';

@freezed
class ConfirmPasswordResetState with _$ConfirmPasswordResetState {
  const factory ConfirmPasswordResetState({
    required TextEditingController controller,
    @Default(false) bool isResending,
  }) = _ConfirmPasswordResetState;
}
