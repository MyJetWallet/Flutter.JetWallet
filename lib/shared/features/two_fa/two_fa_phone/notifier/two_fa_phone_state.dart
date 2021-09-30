import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'two_fa_phone_union.dart';

part 'two_fa_phone_state.freezed.dart';

@freezed
class TwoFaPhoneState with _$TwoFaPhoneState {
  const factory TwoFaPhoneState({
    @Default('') String phoneNumber,
    @Default(false) bool showResend,
    // If phoneVerified this means that smsVerificationService won't work
    // twoFaService has to be used instead
    @Default(false) bool phoneVerified,
    @Default(Input()) TwoFaPhoneUnion union,
    required TextEditingController controller,
  }) = _TwoFaPhoneState;
}
