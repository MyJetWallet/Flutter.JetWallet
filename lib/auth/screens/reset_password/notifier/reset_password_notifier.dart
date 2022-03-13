import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/password_recovery/password_recovery_request_model.dart';
import '../../../../service/shared/models/server_reject_exception.dart';
import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/helpers/password_validators.dart';
import '../../login/login.dart';
import '../view/reset_password.dart';
import 'reset_password_state.dart';
import 'reset_password_union.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier(
    this.read,
    this.args,
  ) : super(const ResetPasswordState());

  final Reader read;
  final ResetPasswordArgs args;

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

  Future<void> resetPassword() async {
    _logger.log(notifier, 'resetPassword');

    final context = read(sNavigatorKeyPod).currentContext!;

    try {
      state = state.copyWith(union: const Loading());

      final model = PasswordRecoveryRequestModel(
        email: args.email,
        password: state.password,
        code: args.code,
      );

      await read(authServicePod).recoverPassword(model);

      SuccessScreen.push(
        context: context,
        secondaryText: 'Your password has been reset',
        then: () => navigatorPush(
          read(sNavigatorKeyPod).currentContext!,
          Login(
            email: args.email,
          ),
        ),
      );

      state = state.copyWith(union: const Input());
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'resetPassword', error.cause);

      Navigator.of(context).pop();

      state = state.copyWith(union: Error(error.cause));
    } catch (e) {
      _logger.log(stateFlow, 'resetPassword', e);

      state = state.copyWith(union: Error(e));
    }
  }
}
