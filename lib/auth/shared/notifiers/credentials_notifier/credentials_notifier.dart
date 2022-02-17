import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/logging/levels.dart';
import '../../helpers/is_email_valid.dart';
import '../../helpers/password_validators.dart';
import 'credentials_state.dart';

/// Used only for [Register] and [Login] flow
class CredentialsNotifier extends StateNotifier<CredentialsState> {
  CredentialsNotifier() : super(const CredentialsState());

  static final _logger = Logger('CredentialsNotifier');

  void updateEmail(String email) {
    _logger.log(notifier, 'updateEmail');

    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    _logger.log(notifier, 'updatePassword');

    state = state.copyWith(password: password);
  }

  void validateEmail() {
    _logger.log(notifier, 'validateEmail');

    if (isEmailValid(state.email)) {
      state = state.copyWith(
        emailValid: true,
      );
    } else {
      state = state.copyWith(emailValid: false);
    }
  }

  void validatePassword() {
    _logger.log(notifier, 'validatePassword');

    if (isPasswordValid(state.password)) {
      state = state.copyWith(
        passwordValid: true,
      );
    } else {
      state = state.copyWith(passwordValid: false);
    }
  }

  void updateAndValidateEmail(String email) {
    _logger.log(notifier, 'updateAndValidateEmail');

    updateEmail(email);
    validateEmail();
  }

  void updateAndValidatePassword(String password) {
    _logger.log(notifier, 'updateAndValidatePassword');

    updatePassword(password);
    validatePassword();
  }

  void checkPolicy() {
    _logger.log(notifier, 'checkPolicy');

    state = state.copyWith(policyChecked: !state.policyChecked);
  }

  void checkOnUpdateOrRemovePassword(
      ValueNotifier<StandardFieldErrorNotifier> passwordError,
      ValueNotifier<StandardFieldErrorNotifier> emailError,
      String password,
      TextEditingController controller,
      ) {
    if (passwordError.value.value && password.length < state.password.length) {
      controller.text = '';
      _disableFieldsError(passwordError, emailError);
      updateAndValidatePassword('');
    } else {
      _disableFieldsError(passwordError, emailError);
      updateAndValidatePassword(password);
    }
  }

  void _disableFieldsError(
      ValueNotifier<StandardFieldErrorNotifier> passwordError,
      ValueNotifier<StandardFieldErrorNotifier> emailError,
      ) {
    emailError.value.disableError();
    passwordError.value.disableError();
  }

  void clear() {
    _logger.log(notifier, 'clear');

    state = const CredentialsState();
  }
}
