import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../../../service/services/authentication/model/authenticate/login_request_model.dart';
import '../../../../../service/services/authentication/model/authenticate/register_request_model.dart';
import '../../../../../service/shared/constants.dart';
import '../../../../../shared/helpers/current_platform.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../router/provider/authorization_stpod/authorization_stpod.dart';
import '../../../../router/provider/authorization_stpod/authorization_union.dart';
import '../../../../service/services/authentication/model/authenticate/authentication_response_model.dart';
import '../../../../service/shared/models/server_reject_exception.dart';
import '../../../../shared/providers/apps_flyer_service_pod.dart';
import '../../../../shared/providers/device_info_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../auth_info_notifier/auth_info_notipod.dart';
import 'authentication_union.dart';

enum AuthOperation { login, register }

class AuthenticationNotifier extends StateNotifier<AuthenticationUnion> {
  AuthenticationNotifier(this.read) : super(const Input());

  final Reader read;

  static final _logger = Logger('AuthenticationNotifier');

  Future<void> authenticate({
    bool? marketingEmailsAllowed,
    required String email,
    required String password,
    required AuthOperation operation,
  }) async {
    _logger.log(notifier, 'authenticate');

    final router = read(authorizationStpod.notifier);
    final authInfoN = read(authInfoNotipod.notifier);
    final authService = read(authServicePod);
    final storageService = read(localStorageServicePod);
    final rsaService = read(rsaServicePod);
    final deviceInfoModel = read(deviceInfoPod);

    try {
      state = const Loading();

      final referralCode = await storageService.getString(referralCodeKey);

      rsaService.init();
      await rsaService.savePrivateKey(storageService);

      final publicKey = rsaService.publicKey;

      final loginRequest = LoginRequestModel(
        publicKey: publicKey,
        email: email,
        password: password,
        platform: currentPlatform,
        deviceUid: deviceInfoModel.deviceUid,
      );

      final registerRequest = RegisterRequestModel(
        publicKey: publicKey,
        email: email,
        password: password,
        platformType: platformType,
        platform: currentPlatform,
        deviceUid: deviceInfoModel.deviceUid,
        referralCode: referralCode,
        marketingEmailsAllowed: marketingEmailsAllowed,
      );

      AuthenticationResponseModel authModel;

      if (operation == AuthOperation.login) {
        authModel = await authService.login(loginRequest);
        unawaited(sAnalytics.loginSuccess(email));
      } else {
        authModel = await authService.register(registerRequest);
        authInfoN.updateResendButton();
        unawaited(sAnalytics.signUpSuccess(email));
        read(appsFlyerServicePod).register(email);
      }

      await storageService.setString(refreshTokenKey, authModel.refreshToken);
      await storageService.setString(userEmailKey, email);

      authInfoN.updateToken(authModel.token);
      authInfoN.updateRefreshToken(authModel.refreshToken);
      authInfoN.updateEmail(email);

      router.state = const Authorized();

      state = const Input();

      read(startupNotipod.notifier).successfullAuthentication();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'authenticate', error.cause);
      if (operation == AuthOperation.login) {
        sAnalytics.loginFailure(email, error.cause);
      } else {
        sAnalytics.signUpFailure(email, error.cause);
      }

      state = Input(error.cause);
    } catch (e) {
      _logger.log(stateFlow, 'authenticate', e);
      if (operation == AuthOperation.login) {
        sAnalytics.loginFailure(email, e.toString());
      } else {
        sAnalytics.signUpFailure(email, e.toString());
      }

      if (e is DioError && e.error == 'Http status error [401]') {
        state = const Input('Invalid login or password');
      } else {
        state = const Input('Something went wrong. Please try again later!');
      }
    }
  }
}
