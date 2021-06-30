import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../service/services/validation/model/send_email_verification_code_request_model.dart';
import '../../../../service/services/validation/model/verify_email_verification_code_request_model.dart';
import '../../../../service/services/validation/service/validation_service.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/logging/levels.dart';
import '../../email_verification_success/email_verification_success.dart';
import 'email_verification_state.dart';
import 'email_verification_union.dart';

class EmailVerificationNotifier extends StateNotifier<EmailVerificationState> {
  EmailVerificationNotifier({
    required this.email,
    required this.service,
    required this.context,
  }) : super(
          EmailVerificationState(
            email: email,
            union: const Input(),
            controller: TextEditingController(),
          ),
        );

  final String email;
  final ValidationService service;
  final BuildContext context;

  static final _logger = Logger('EmailVerificationNotifier');

  // void updateCode(String? code) {
  //   // we need to addPostFrameCallback because updateCode
  //   // is triggered inside initState which results in UncontrolledProviderScope
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     _logger.log(notifier, 'updateCode');
  //   });

  //   state = state.copyWith(code: code);
  // }

  void updateController(String? code) {
    _logger.log(notifier, 'updateController');

    state = state.copyWith(
      controller: TextEditingController(text: code),
    );
  }

  Future<void> sendCode() async {
    _logger.log(notifier, 'sendCode');

    state = state.copyWith(union: const Loading());

    final model = SendEmailVerificationCodeRequestModel(
      language: AppLocalizations.of(context)!.localeName,
      deviceType: deviceType,
    );

    try {
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

    final model = VerifyEmailVerificationCodeRequestModel(
      code: state.controller.text,
    );

    try {
      await service.verifyEmailVerificationCode(model);

      state = state.copyWith(union: const Input());

      navigatorPush(context, const EmailVerificationSuccess());
    } catch (e) {
      _logger.log(stateFlow, 'verifyCode', e);

      state = state.copyWith(union: Error(e));
    }
  }
}
