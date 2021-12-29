import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState {
  const factory PhoneNumberState({
    String? asset,
    String? phoneNumber,
    String? countryName,
    SPhoneNumber? activeDialCode,
    @Default('') String dialCodeSearch,
    @Default('') String? countryCode,
    @Default([]) List<SPhoneNumber> sortedDialCodes,
    required TextEditingController dialCodeController,
    required TextEditingController phoneNumberController,
  }) = _PhoneNumberState;

  const PhoneNumberState._();

  bool get isReadyToContinue {
    return dialCodeController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
  }
}
