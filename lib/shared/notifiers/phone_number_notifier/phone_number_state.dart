import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState {
  const factory PhoneNumberState({
    String? asset,
    String? countryName,
    SPhoneNumber? activeDialCode,
    @Default('') String phoneNumber,
    @Default('') String dialCodeSearch,
    @Default([]) List<SPhoneNumber> sortedDialCodes,
    required TextEditingController dialCodeController,
  }) = _PhoneNumberState;

  const PhoneNumberState._();

  String get countryCode {
    return dialCodeController.text;
  }
}
