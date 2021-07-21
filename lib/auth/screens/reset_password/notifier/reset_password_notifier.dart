import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/password_recovery/password_recovery_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../../shared/helpers/password_validators.dart';
import 'reset_password_state.dart';
import 'reset_password_union.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier({
    required this.authService,
  }) : super(const ResetPasswordState());

  final AuthenticationService authService;

  static final _logger = Logger('ResetPasswordNotifier');

  void updatePassword(String password) {
    _logger.log(notifier, 'updatePassword');

    state = state.copyWith(password: password);
  }

  void validatePassword() {
    _logger.log(notifier, 'validatePassword');

    if (isPasswordValid(state.password)) {
      state = state.copyWith(passwordValid: true);
    } else {
      state = state.copyWith(passwordValid: false);
    }
  }

  void updateAndValidatePassword(String password) {
    state = state.copyWith(union: const Input());

    updatePassword(password);
    validatePassword();
  }

  Future<void> resetPassword(String token) async {
    _logger.log(notifier, 'resetPassword');

    try {
      state = state.copyWith(union: const Loading());

      final model = PasswordRecoveryRequestModel(
        password: state.password,
        token: token,
      );

      await authService.recoverPassword(model);

      state = state.copyWith(union: const Input());
    } catch (e) {
      _logger.log(stateFlow, 'resetPassword', e);

      state = state.copyWith(union: Error(e));
    }
  }
}
