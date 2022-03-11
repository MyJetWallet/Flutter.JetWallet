import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/authentication/model/forgot_password/forgot_password_request_model.dart';
import '../../../../../service/services/authentication/model/password_recovery/password_recovery_request_model.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../shared/helpers/device_type.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../reset_password/view/reset_password.dart';
import 'confirm_password_reset_state.dart';
import 'confirm_password_reset_union.dart';

class ConfirmPasswordResetNotifier
    extends StateNotifier<ConfirmPasswordResetState> {
  ConfirmPasswordResetNotifier(
    this.read,
    this.email,
  ) : super(
          ConfirmPasswordResetState(
            controller: TextEditingController(),
          ),
        ) {
    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;
  final String email;

  late BuildContext _context;

  static final _logger = Logger('ConfirmPasswordResetNotifier');

  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    state.controller.text = code ?? '';
  }

  Future<void> resendCode({required Function() onSuccess}) async {
    _logger.log(notifier, 'resendCode');

    state = state.copyWith(union: const Loading());

    _updateIsResending(true);

    try {
      final model = ForgotPasswordRequestModel(
        email: email,
        deviceType: deviceType,
      );

      await read(authServicePod).forgotPassword(model);

      if (!mounted) return;
      _updateIsResending(false);
      onSuccess();
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);
      _updateIsResending(false);
      read(sNotificationNotipod.notifier).showError(
        'Failed to resend. Try again!',
      );
    }
  }

  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    state = state.copyWith(union: const Loading());

    try {
      final model = PasswordRecoveryRequestModel(
        email: email,
        // TODO: Fix when backend will add new code validation api
        password: '12345qwert',
        code: state.controller.text,
      );

      await read(authServicePod).recoverPassword(model);

      state = state.copyWith(union: const Input());

      if (!mounted) return;

      Navigator.of(_context).pop();
      unawaited(
        ResetPassword.push(
          context: _context,
          args: ResetPasswordArgs(
            email: email,
            code: state.controller.text,
          ),
        ),
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      state = state.copyWith(union: Error(error.cause));
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      state = state.copyWith(union: Error(error));
    }
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }
}
