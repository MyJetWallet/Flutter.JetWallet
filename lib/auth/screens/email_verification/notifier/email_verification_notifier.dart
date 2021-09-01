import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../router/provider/authorized_stpod/authorized_union.dart';
import '../../../../service/services/validation/model/send_email_verification_code_request_model.dart';
import '../../../../service/services/validation/model/verify_email_verification_code_request_model.dart';
import '../../../../service/services/validation/service/validation_service.dart';
import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../../shared/logging/levels.dart';
import 'email_verification_state.dart';
import 'email_verification_union.dart';

class EmailVerificationNotifier extends StateNotifier<EmailVerificationState> {
  EmailVerificationNotifier({
    required this.read,
    required this.email,
    required this.service,
    required this.authorized,
    required this.context,
  }) : super(
          EmailVerificationState(
            email: email,
            union: const Input(),
            controller: TextEditingController(),
          ),
        );

  final Reader read;
  final String email;
  final ValidationService service;
  final StateController<AuthorizedUnion> authorized;
  final BuildContext context;

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
        language: AppLocalizations.of(context)!.localeName,
        deviceType: deviceType,
      );

      await service.sendEmailVerificationCode(model);

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

      await service.verifyEmailVerificationCode(model);

      // Needed force refresh after successful emailVerification
      await refreshToken(read);

      state = state.copyWith(union: const Input());

      authorized.state = const Home();

      if (!mounted) return;
      _pushToAuthSuccess(context, email);
    } catch (e) {
      _logger.log(stateFlow, 'verifyCode', e);

      state = state.copyWith(union: Error(e));
    }
  }
}

void _pushToAuthSuccess(BuildContext context, String email) {
  navigatorPush(
    context,
    SuccessScreen(
      header: 'Email Verification',
      description: 'Your email address $email is confirmed',
    ),
  );
}
