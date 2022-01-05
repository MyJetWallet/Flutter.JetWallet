import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'email_verification_union.dart';

part 'email_verification_state.freezed.dart';

@freezed
class EmailVerificationState with _$EmailVerificationState {
  const factory EmailVerificationState({
    @Default('') String email,
    @Default(Input()) EmailVerificationUnion union,
    required TextEditingController controller,
    @Default(false) bool isResending,
  }) = _EmailVerificationState;
}
