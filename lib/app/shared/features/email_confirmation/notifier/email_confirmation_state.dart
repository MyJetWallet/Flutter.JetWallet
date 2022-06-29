import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'email_confirmation_union.dart';

part 'email_confirmation_state.freezed.dart';

@freezed
class EmailConfirmationState with _$EmailConfirmationState {
  const factory EmailConfirmationState({
    @Default('') String email,
    @Default(Input()) EmailConfirmationUnion union,
    required TextEditingController controller,
    @Default(true) bool isResending,
    @Default(false) bool showResendButton,
  }) = _EmailConfirmationState;
}
