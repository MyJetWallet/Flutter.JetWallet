import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../service/services/authentication/model/forgot_password/forgot_password_request_model.dart';
import '../../../../../shared/helpers/device_type.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../shared/helpers/is_email_valid.dart';
import '../../view/confirm_password_reset.dart';
import '../../view/forgot_password.dart';
import 'forgot_password_state.dart';
import 'forgot_password_union.dart';

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier(
    this.read,
    this.args,
  ) : super(const ForgotPasswordState()) {
    updateAndValidateEmail(args.email);
  }

  final Reader read;
  final ForgotPasswordArgs args;

  static final _logger = Logger('ForgotPasswordNotifier');

  void updateAndValidateEmail(String email) {
    _logger.log(notifier, 'updateAndValidateEmail');

    state = state.copyWith(union: const Input());

    _updateEmail(email);
    validateEmail();
  }

  void validateEmail() {
    _logger.log(notifier, 'validateEmail');

    if (isEmailValid(state.email)) {
      state = state.copyWith(emailValid: true);
    } else {
      state = state.copyWith(emailValid: false);
    }
  }

  void _updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  Future<void> sendRecoveryLink() async {
    _logger.log(notifier, 'sendRecoveryLink');

    try {
      state = state.copyWith(union: const Loading());

      final model = ForgotPasswordRequestModel(
        email: state.email,
        deviceType: deviceType,
      );

      await read(authServicePod).forgotPassword(model);

      unawaited(
        ConfirmPasswordReset.push(
          context: read(sNavigatorKeyPod).currentContext!,
          args: ConfirmPasswordResetArgs(
            email: state.email,
          ),
        ),
      );

      state = state.copyWith(union: const Input());
    } catch (e) {
      _logger.log(stateFlow, 'sendRecoveryLink', e);

      state = state.copyWith(
        union: const Error('Something went wrong'),
      );
    }
  }
}
