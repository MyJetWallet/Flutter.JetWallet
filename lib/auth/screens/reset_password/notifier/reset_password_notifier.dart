import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/password_recovery/password_recovery_request_model.dart';
import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/helpers/password_validators.dart';
import '../../login/login.dart';
import 'reset_password_state.dart';
import 'reset_password_union.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier(this.read) : super(const ResetPasswordState());

  final Reader read;

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

      await read(authServicePod).recoverPassword(model);

      final context = read(sNavigatorKeyPod).currentContext!;

      SuccessScreen.push(
        context: context,
        secondaryText: 'Your password has been reset',
        then: () => Login.push(context),
      );

      state = state.copyWith(union: const Input());
    } catch (e) {
      _logger.log(stateFlow, 'resetPassword', e);

      state = state.copyWith(union: Error(e));
    }
  }
}
