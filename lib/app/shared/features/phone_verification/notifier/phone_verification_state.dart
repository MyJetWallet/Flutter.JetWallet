import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'phone_verification_state.freezed.dart';

@freezed
class PhoneVerificationState with _$PhoneVerificationState {
  const factory PhoneVerificationState({
    StackLoaderNotifier? loader,
    StandardFieldErrorNotifier? pinFieldError,
    @Default('') String phoneNumber,
    @Default(false) bool showResend,
    required TextEditingController controller,
  }) = _PhoneVerificationState;
}
