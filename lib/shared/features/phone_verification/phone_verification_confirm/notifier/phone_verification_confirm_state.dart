import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'phone_verification_confirm_union.dart';

part 'phone_verification_confirm_state.freezed.dart';

@freezed
class PhoneVerificationConfirmState with _$PhoneVerificationConfirmState {
  const factory PhoneVerificationConfirmState({
    @Default('') String phoneNumber,
    @Default(false) bool showResend,
    @Default(Input()) PhoneVerificationConfirmUnion union,
    required TextEditingController controller,
  }) = _PhoneVerificationConfirmState;
}
