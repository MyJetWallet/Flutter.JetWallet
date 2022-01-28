import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/is_phone_number_valid.dart';

part 'set_phone_number_state.freezed.dart';

@freezed
class SetPhoneNumberState with _$SetPhoneNumberState {
  const factory SetPhoneNumberState({
    SPhoneNumber? activeDialCode,
    StackLoaderNotifier? loader,
    StandardFieldErrorNotifier? phoneFieldError,
    @Default('') String dialCodeSearch,
    @Default([]) List<SPhoneNumber> sortedDialCodes,
    required TextEditingController dialCodeController,
    required TextEditingController phoneNumberController,
  }) = _SetPhoneNumberState;

  const SetPhoneNumberState._();

  String get phoneNumber {
    return dialCodeController.text + phoneNumberController.text;
  }

  bool get isReadyToContinue {
    final condition1 = dialCodeController.text.isNotEmpty;
    final condition2 = phoneNumberController.text.isNotEmpty;
    final condition3 = validWeakPhoneNumber(phoneNumber);

    return condition1 && condition2 && condition3;
  }
}
