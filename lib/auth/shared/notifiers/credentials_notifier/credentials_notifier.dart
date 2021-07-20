import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

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
      state = state.copyWith(emailValid: true);
    } else {
      state = state.copyWith(emailValid: false);
    }
  }

  void validatePassword() {
    _logger.log(notifier, 'validatePassword');

    if (isPasswordValid(state.password)) {
      state = state.copyWith(passwordValid: true);
    } else {
      state = state.copyWith(passwordValid: false);
    }
  }

  void updateAndValidateEmail(String email) {
    updateEmail(email);
    validateEmail();
  }

  void updateAndValidatePassword(String password) {
    updatePassword(password);
    validatePassword();
  }

  void checkPolicy() {
    _logger.log(notifier, 'checkPolicy');

    state = state.copyWith(policyChecked: !state.policyChecked);
  }

  bool get readyToRegister {
    return state.emailValid && state.passwordValid;
  }

  bool get readyToLogin {
    return state.emailValid && state.password.isNotEmpty;
  }

  bool get emailValidAndPolicyChecked {
    return state.emailValid && state.policyChecked;
  }

  void clear() {
    _logger.log(notifier, 'clear');

    state = const CredentialsState();
  }
}
