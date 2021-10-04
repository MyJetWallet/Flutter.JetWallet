import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_enter_state.freezed.dart';

@freezed
class PhoneVerificationEnterState with _$PhoneVerificationEnterState {
  const factory PhoneVerificationEnterState({
    @Default(false) bool valid,
    @Default('') String? phoneNumber,
  }) = _PhoneVerificationEnterState;
}
