
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/authentication/model/confirm_email_login/confirm_email_login_request_model.dart';
import 'package:simple_networking/services/authentication/model/start_email_login/start_email_login_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';


import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/helpers/current_platform.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/apps_flyer_service_pod.dart';
import '../../../../shared/providers/device_info_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';

import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../view/components/email_confirmed_success_text.dart';
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

  Future<void> resendCode() async {
    _logger.log(notifier, 'resendCode');
    final deviceInfoModel = read(deviceInfoPod);
    final appsFlyerService = read(appsFlyerServicePod);
    final intl = read(intlPod);
    final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
    final authService = read(authServicePod);
    final authInfoN = read(authInfoNotipod.notifier);
    final credentials = read(credentialsNotipod);
    _updateIsResending(true);
    try {
      final model = StartEmailLoginRequestModel(
        email: credentials.email,
        platform: currentPlatform,
        deviceUid: deviceInfoModel.deviceUid,
        lang: intl.localeName,
        application: currentPlatform,
        appsflyerId: appsFlyerID ?? '',
      );
      final response =
      await authService.startEmailLogin(model, intl.localeName);
      authInfoN.updateEmail(credentials.email);
      authInfoN.updateVerificationToken(response.verificationToken);
      read(timerNotipod(emailResendCountdown).notifier).refreshTimer();
      if (!mounted) return;
      _updateIsResending(false);
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
    final authService = read(authServicePod);
    final storageService = read(localStorageServicePod);
    final rsaService = read(rsaServicePod);
    final authInfo = read(authInfoNotipod);
    final authInfoN = read(authInfoNotipod.notifier);
    rsaService.init();
    await rsaService.savePrivateKey(storageService);
    final publicKey = rsaService.publicKey;

    try {
      final model = ConfirmEmailLoginRequestModel(
        verificationToken: authInfo.verificationToken,
        code: state.controller.text,
        publicKeyPem: publicKey,
        email:authInfo.email,
      );

      final intl = read(intlPod);
      final response =
          await authService.confirmEmailLogin(model, intl.localeName);
      read(authInfoNotipod.notifier).state.copyWith(token: response.token);
      await storageService.setString(refreshTokenKey,   response.refreshToken);
      await storageService.setString(userEmailKey, authInfo.email);
      authInfoN.updateToken(response.token);
      authInfoN.updateRefreshToken(response.refreshToken);
      state = state.copyWith(union: const Input());

      if (!mounted) return;

      SuccessScreen.push(
        context: _context,
        specialTextWidget: EmailConfirmedSuccessText(
          email: state.email,
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

  void _updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }
}
