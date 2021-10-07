import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_input_phone_number_state.freezed.dart';

@freezed
class SendInputPhoneNumberState with _$SendInputPhoneNumberState {
  const factory SendInputPhoneNumberState({
    @Default(false) bool valid,
    @Default('') String phoneNumber,
  }) = _SendInputPhoneNumberState;
}
