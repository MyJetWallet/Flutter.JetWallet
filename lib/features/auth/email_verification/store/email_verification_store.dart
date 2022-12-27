import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/auth/email_verification/model/email_verification_union.dart';
import 'package:jetwallet/utils/helpers/current_platform.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/confirm_email_login/confirm_email_login_request_model.dart';
import 'package:simple_networking/modules/auth_api/models/start_email_login/start_email_login_request_model.dart';

part 'email_verification_store.g.dart';

@lazySingleton
class EmailVerificationStore extends _EmailVerificationStoreBase
    with _$EmailVerificationStore {
  EmailVerificationStore() : super();

  static _EmailVerificationStoreBase of(BuildContext context) =>
      Provider.of<EmailVerificationStore>(context, listen: false);
}

abstract class _EmailVerificationStoreBase with Store {
  _EmailVerificationStoreBase() {
    _updateEmail(getIt.get<AppStore>().authState.email);
  }

  static final _logger = Logger('EmailVerificationStore');

  final loader = StackLoaderStore();

  @observable
  String email = '';

  @observable
  EmailVerificationUnion union = const EmailVerificationUnion.input();

  @observable
  bool isResending = false;

  @observable
  TextEditingController controller = TextEditingController();

  @action
  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    controller.text = code ?? '';
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 6) {
      try {
        int.parse(code);
        controller.text = code;
      } catch (e) {
        return;
      }
    }
  }

  @action
  Future<void> resendCode(TimerStore timer) async {
    _logger.log(notifier, 'resendCode');

    final deviceInfoModel = sDeviceInfo.model;
    final appsFlyerService = getIt.get<AppsFlyerService>();
    final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
    final credentials = getIt.get<CredentialsService>();

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
      final response = await getIt
          .get<SNetwork>()
          .simpleNetworkingUnathorized
          .getAuthModule()
          .postStartEmailLogin(model);

      response.pick(
        onData: (data) {
          getIt.get<AppStore>().updateAuthState(email: credentials.email);
          getIt.get<AppStore>().updateVerificationToken(data.verificationToken);

          timer.refreshTimer();

          _updateIsResending(false);
        },
        onError: (error) {
          _logger.log(stateFlow, 'sendCode', error);

          _updateIsResending(false);
          sNotification.showError(
            '${intl.emailVerification_failedToResend}!',
          );
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      _updateIsResending(false);
      sNotification.showError(
        '${intl.emailVerification_failedToResend}!',
      );
    }

    /*
    final authService = read(authServicePod);
    final authInfoN = getIt.get<AppStore>().authState;

    final credentials = getIt.get<CredentialsService>();

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
          await sNetwork.getAuthModule().postStartEmailLogin(model);

      response.pick(
        onData: (data) {
          authInfoN.updateEmail(credentials.email);
          authInfoN.updateVerificationToken(data.verificationToken);

          read(timerNotipod(emailResendCountdown).notifier).refreshTimer();

          _updateIsResending(false);
        },
        onError: (e) {
          _logger.log(stateFlow, 'sendCode', e);

          _updateIsResending(false);
          sNotification.showError(
            '${intl.emailVerification_failedToResend}!',
          );
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      _updateIsResending(false);
      sNotification.showError(
        '${intl.emailVerification_failedToResend}!',
      );
    }
    */
  }

  // TODO: refactor

  @action
  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    union = const EmailVerificationUnion.loading();

    final storageService = sLocalStorageService;
    final rsaService = getIt.get<RsaService>();

    final authInfo = getIt.get<AppStore>();

    rsaService.init();
    await rsaService.savePrivateKey(storageService);
    final publicKey = rsaService.publicKey;

    try {
      final model = ConfirmEmailLoginRequestModel(
        verificationToken: authInfo.authState.verificationToken,
        code: controller.text,
        publicKeyPem: publicKey,
        email: authInfo.authState.email,
      );

      final response = await getIt
          .get<SNetwork>()
          .simpleNetworkingUnathorized
          .getAuthModule()
          .postConfirmEmailLogin(model);

      response.pick(
        onData: (data) async {
          await storageService.setString(
            refreshTokenKey,
            data.refreshToken,
          );
          await storageService.setString(
            userEmailKey,
            authInfo.authState.email,
          );

          authInfo.updateAuthState(
            token: data.token,
            refreshToken: data.refreshToken,
          );

          print('TOKEN SAVED');
          print(authInfo.authState.token);

          print('REFRESHTOKEN SAVED');
          print(authInfo.authState.refreshToken);

          union = const EmailVerificationUnion.input();

          await startSession(authInfo.authState.email);

          authInfo.setAuthStatus(const AuthorizationUnion.authorized());
          getIt.get<StartupService>().successfullAuthentication();

          unawaited(getIt.get<AppStore>().checkInitRouter());

          //_logger.log(stateFlow, 'verifyCode', state);
        },
        onError: (error) {
          _logger.log(stateFlow, 'verifyCode', error.cause);

          union = error.cause.contains('50') || error.cause.contains('40')
              ? EmailVerificationUnion.error(
                  intl.something_went_wrong_try_again)
              : EmailVerificationUnion.error(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      union = error.cause.contains('50') || error.cause.contains('40')
          ? EmailVerificationUnion.error(intl.something_went_wrong_try_again)
          : EmailVerificationUnion.error(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      union = error.toString().contains('50') || error.toString().contains('40')
          ? EmailVerificationUnion.error(intl.something_went_wrong_try_again)
          : EmailVerificationUnion.error(error);
    }

    /*
    union = const EmailVerificationUnion.loading();

    final authService = read(authServicePod);
    final storageService = sLocalStorageService;
    final rsaService = getIt.get<RsaService>();

    final authInfo = getIt.get<AppStore>().authState;
    final authInfoN = read(authInfoNotipod.notifier);
    final router = read(authorizationStpod.notifier);

    rsaService.init();
    await rsaService.savePrivateKey(storageService);
    final publicKey = rsaService.publicKey;

    try {
      final model = ConfirmEmailLoginRequestModel(
        verificationToken: authInfo.verificationToken,
        code: controller.text,
        publicKeyPem: publicKey,
        email: authInfo.email,
      );

      final response =
          await sNetwork.getAuthModule().postConfirmEmailLogin(model);

      response.pick(
        onData: (data) async {
          read(authInfoNotipod.notifier).state.copyWith(token: response.token);

          await storageService.setString(
            refreshTokenKey,
            data.refreshToken,
          );
          await storageService.setString(userEmailKey, authInfo.email);

          authInfoN.updateToken(data.token);
          authInfoN.updateRefreshToken(data.refreshToken);

          router.state = const Authorized();

          read(startupNotipod.notifier).successfullAuthentication();

          union = const EmailVerificationUnion.input();

          await startSession(authInfo.email);

          _logger.log(stateFlow, 'verifyCode', state);
        },
        onError: (error) {
          _logger.log(stateFlow, 'verifyCode', error.cause);

          union = EmailVerificationUnion.error(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      union = EmailVerificationUnion.error(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      union = EmailVerificationUnion.error(error);
    }
    */
  }

  @action
  void _updateEmail(String _email) {
    email = _email;
  }

  @action
  void _updateIsResending(bool value) {
    isResending = value;
  }

  @action
  Future<void> startSession(String email) async {
    final appsFlyerService = getIt.get<AppsFlyerService>();

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

  @action
  void clearStore() {
    loader.finishLoadingImmediately();
    email = '';
    union = const EmailVerificationUnion.input();
    isResending = false;
    controller = TextEditingController(text: '');
  }
}
