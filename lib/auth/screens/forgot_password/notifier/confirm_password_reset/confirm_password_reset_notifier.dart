import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/authentication/model/forgot_password/forgot_password_request_model.dart';

import '../../../../../shared/helpers/device_type.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'confirm_password_reset_state.dart';

class ConfirmPasswordResetNotifier
    extends StateNotifier<ConfirmPasswordResetState> {
  ConfirmPasswordResetNotifier(
    this.read,
    this.email,
  ) : super(
          ConfirmPasswordResetState(
            controller: TextEditingController(),
          ),
        );

  final Reader read;
  final String email;

  static final _logger = Logger('ConfirmPasswordResetNotifier');

  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    state.controller.text = code ?? '';
  }

  Future<void> resendCode({required Function() onSuccess}) async {
    _logger.log(notifier, 'resendCode');

    _updateIsResending(true);

    try {
      final model = ForgotPasswordRequestModel(
        email: email,
        deviceType: deviceType,
      );

      final intl = read(intlPod);
      await read(authServicePod).forgotPassword(model, intl.localeName);

      if (!mounted) return;
      _updateIsResending(false);
      onSuccess();
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      final intl = read(intlPod);
      _updateIsResending(false);
      read(sNotificationNotipod.notifier).showError(
        '${intl.confirmPasswordReset_failedToResend}!',
      );
    }
  }

  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 6) {
      try {
        int.parse(code);
        state.controller.text = code;
      } catch (e) {
        return;
      }
    }
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }
}
