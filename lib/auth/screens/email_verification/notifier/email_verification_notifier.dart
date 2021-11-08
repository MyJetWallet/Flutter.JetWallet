import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../service/services/validation/model/send_email_verification_code_request_model.dart';
import '../../../../service/services/validation/model/verify_email_verification_code_request_model.dart';
import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import 'email_verification_state.dart';
import 'email_verification_union.dart';

class EmailVerificationNotifier extends StateNotifier<EmailVerificationState> {
  EmailVerificationNotifier(
    this.read,
  ) : super(
          EmailVerificationState(
            controller: TextEditingController(),
          ),
        ) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateEmail(read(authInfoNotipod).email);
  }

  final Reader read;

  late BuildContext _context;

  static final _logger = Logger('EmailVerificationNotifier');

  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    state.controller.text = code ?? '';
  }

  Future<void> sendCode() async {
    _logger.log(notifier, 'sendCode');

    state = state.copyWith(union: const Loading());

    try {
      final model = SendEmailVerificationCodeRequestModel(
        language: read(intlPod).localeName,
        deviceType: deviceType,
      );

      await read(validationServicePod).sendEmailVerificationCode(model);

      state = state.copyWith(union: const Input());
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      state = state.copyWith(union: Error(e));
    }
  }

  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    state = state.copyWith(union: const Loading());

    try {
      final model = VerifyEmailVerificationCodeRequestModel(
        code: state.controller.text,
      );

      await read(validationServicePod).verifyEmailVerificationCode(model);

      // Needed force refresh after successful emailVerification
      await refreshToken(read);

      state = state.copyWith(union: const Input());

      if (!mounted) return;
      _pushToAuthSuccess(
        _context,
        state.email,
        read(startupNotipod.notifier).emailVerified,
      );
    } catch (e) {
      _logger.log(stateFlow, 'verifyCode', e);

      state = state.copyWith(union: Error(e));
    }
  }

  void _updateEmail(String email) {
    state = state.copyWith(email: email);
  }
}

void _pushToAuthSuccess(
  BuildContext context,
  String email,
  void Function() then,
) {
  navigatorPush(
    context,
    SuccessScreen(
      header: 'Email Verification',
      text1: 'Your email address',
      text2: email,
      text3: 'is confirmed',
    ),
    then,
  );
}
