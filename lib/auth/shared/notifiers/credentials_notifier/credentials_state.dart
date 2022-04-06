import 'package:freezed_annotation/freezed_annotation.dart';

import '../../helpers/password_validators.dart';

part 'credentials_state.freezed.dart';

@freezed
class CredentialsState with _$CredentialsState {
  const factory CredentialsState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool emailValid,
    @Default(false) bool passwordValid,
    @Default(false) bool policyChecked,
    @Default(false) bool mailingChecked,
  }) = _CredentialsState;

  const CredentialsState._();

  bool get emailIsNotEmptyAndPolicyChecked {
    return email.isNotEmpty && policyChecked;
  }

  bool get readyToRegister {
    return emailValid && passwordValid;
  }

  bool get readyToLogin {
    return emailValid && isPasswordLengthValid(password);
  }
}
