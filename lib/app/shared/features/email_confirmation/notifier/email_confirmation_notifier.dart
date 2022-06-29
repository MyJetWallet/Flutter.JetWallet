import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/confirmation/model/send_email_confirmation_request.dart';
import 'package:simple_networking/services/confirmation/model/send_email_confirmation_response.dart';
import 'package:simple_networking/services/confirmation/model/verify_email_confirmation_request.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../shared/helpers/device_type.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../delete_profile/view/delete_reasons_screen.dart';
import 'email_confirmation_state.dart';
import 'email_confirmation_union.dart';

class EmailConfirmationNotifier extends StateNotifier<EmailConfirmationState> {
  EmailConfirmationNotifier(
    this.read,
  ) : super(
          EmailConfirmationState(
            controller: TextEditingController(),
          ),
        ) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateEmail(read(authInfoNotipod).email);
  }

  final Reader read;

  late BuildContext _context;

  static final _logger = Logger('EmailVerificationNotifier');

  SendEmailConfirmationResponse? sendEmailResponse;

  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    state.controller.text = code ?? '';
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

  Future<void> resendCode({required Function() onSuccess}) async {
    _logger.log(notifier, 'resendCode');

    _updateIsResending(true);

    try {
      final model = SendEmailConfirmationRequest(
        language: read(intlPod).localeName,
        deviceType: deviceType,
        type: 1,
        reason: 9,
      );

      final intl = read(intlPod);
      sendEmailResponse =
          await read(confirmationServicePod).sendEmailConfirmationCode(
        model,
        intl.localeName,
      );

      if (!mounted) return;
      _updateIsResending(false);

      onSuccess();
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      final intl = read(intlPod);
      _updateIsResending(false);
      read(sNotificationNotipod.notifier).showError(
        '${intl.emailVerification_failedToResend}!',
      );
    }
  }

  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    state = state.copyWith(union: const Loading());

    try {
      final model = VerifyEmailConfirmationRequest(
        tokenId: sendEmailResponse?.tokenId ?? '',
        verificationId: sendEmailResponse?.verificationId ?? '',
        code: state.controller.text,
      );

      final intl = read(intlPod);
      await read(confirmationServicePod).verifyEmailConfirmation(
        model,
        intl.localeName,
      );

      state = state.copyWith(union: const Input());

      if (!mounted) return;

      read(authInfoNotipod.notifier).updateDeleteToken(
        sendEmailResponse?.tokenId ?? '',
      );

      navigatorPush(_context, const DeleteReasonsScreen());
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      state = state.copyWith(union: Error(error.cause));
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      state = state.copyWith(union: Error(error));
    }
  }

  void _updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }
}
