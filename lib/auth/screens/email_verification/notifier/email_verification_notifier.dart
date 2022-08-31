import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/authentication/model/confirm_email_login/confirm_email_login_request_model.dart';
import 'package:simple_networking/services/authentication/model/start_email_login/start_email_login_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../router/provider/authorization_stpod/authorization_stpod.dart';
import '../../../../router/provider/authorization_stpod/authorization_union.dart';
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
    _updateEmail(read(authInfoNotipod).email);
  }

  final Reader read;

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
        application: currentAppPlatform,
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
    final router = read(authorizationStpod.notifier);

    rsaService.init();
    await rsaService.savePrivateKey(storageService);
    final publicKey = rsaService.publicKey;

    try {
      final model = ConfirmEmailLoginRequestModel(
        verificationToken: authInfo.verificationToken,
        code: state.controller.text,
        publicKeyPem: publicKey,
        email: authInfo.email,
      );
      final intl = read(intlPod);
      final response =
          await authService.confirmEmailLogin(model, intl.localeName);
      read(authInfoNotipod.notifier).state.copyWith(token: response.token);
      await storageService.setString(refreshTokenKey, response.refreshToken);
      await storageService.setString(userEmailKey, authInfo.email);
      authInfoN.updateToken(response.token);
      authInfoN.updateRefreshToken(response.refreshToken);

      router.state = const Authorized();
      read(startupNotipod.notifier).successfullAuthentication();
      state = state.copyWith(union: const Input());
      await startSession(authInfo.email);
      _logger.log(stateFlow, 'verifyCode', state);
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);
      final intl = read(intlPod);
      if (error.cause.contains('500')) {
        state = state.copyWith(
          union: Error(intl.something_went_wrong_try_again),
        );
      } else {
        state = state.copyWith(union: Error(error.cause));
      }
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);
      final intl = read(intlPod);

      if (error.toString().contains('500')) {
        state = state.copyWith(
          union: Error(intl.something_went_wrong_try_again),
        );
      } else {
        state = state.copyWith(union: Error(error));
      }
    }
  }

  void _updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }

  Future<void> startSession(String email) async {
    final appsFlyerService = read(appsFlyerServicePod);
    final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
    final bytes = utf8.encode(email);
    final hashEmail = sha256.convert(bytes).toString();
    appsFlyerService.appsflyerSdk.setCustomerUserId(hashEmail);
    await appsFlyerService.appsflyerSdk.logEvent('Start Session', {
      'Customer User iD': hashEmail,
      'Appsflyer ID': appsFlyerID,
      'Registration/Login/SSO': 'SSO',
    });
  }
}
