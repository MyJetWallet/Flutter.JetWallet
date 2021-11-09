import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials_state.freezed.dart';

@freezed
class CredentialsState with _$CredentialsState {
  const factory CredentialsState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool emailValid,
    @Default(false) bool passwordValid,
    @Default(false) bool policyChecked,
    @Default(false) bool readyToLogin,
  }) = _CredentialsState;
}
