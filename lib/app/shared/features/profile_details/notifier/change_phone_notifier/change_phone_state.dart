import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_phone_state.freezed.dart';

@freezed
class ChangePhoneState with _$ChangePhoneState {
  const factory ChangePhoneState({
    @Default('') String phone,
    @Default(false) bool phoneConfirmed,
    @Default('') String isoCode,
  }) = _ChangePhoneState;

  const ChangePhoneState._();

  bool get enableChangePhoneNumber => phone.isNotEmpty;

  String get phoneNumber => '$isoCode$phone';
}
