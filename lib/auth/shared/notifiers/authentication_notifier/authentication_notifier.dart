import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/authentication/model/authenticate/login_request_model.dart';
import '../../../../../service/services/authentication/model/authenticate/register_request_model.dart';
import '../../../../../service/shared/constants.dart';
import '../../../../../shared/helpers/current_platform.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../router/provider/router_stpod/router_stpod.dart';
import '../../../../router/provider/router_stpod/router_union.dart';
import '../../../../service/services/authentication/model/authenticate/authentication_response_model.dart';
import '../../../../shared/helpers/device_uid.dart';
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
    required String email,
    required String password,
    required AuthOperation operation,
  }) async {
    _logger.log(notifier, 'authenticate');

    final router = read(routerStpod.notifier);
    final authInfoN = read(authInfoNotipod.notifier);
    final authService = read(authServicePod);
    final storageService = read(localStorageServicePod);
    final rsaService = read(rsaServicePod);

    try {
      state = const Loading();

      await rsaService.init();
      await rsaService.savePrivateKey(storageService);

      final publicKey = rsaService.publicKey;

      final id = await deviceUid();

      final loginRequest = LoginRequestModel(
        publicKey: publicKey,
        email: email,
        password: password,
        platform: currentPlatform,
        deviceUid: id,
      );

      final registerRequest = RegisterRequestModel(
        publicKey: publicKey,
        email: email,
        password: password,
        platformType: platformType,
        platform: currentPlatform,
        deviceUid: id,
      );

      AuthenticationResponseModel authModel;

      if (operation == AuthOperation.login) {
        authModel = await authService.login(loginRequest);
      } else {
        authModel = await authService.register(registerRequest);
        authInfoN.updateResendButton();
      }

      await storageService.setString(refreshTokenKey, authModel.refreshToken);
      await storageService.setString(userEmailKey, email);

      authInfoN.updateToken(authModel.token);
      authInfoN.updateRefreshToken(authModel.refreshToken);
      authInfoN.updateEmail(email);

      router.state = const Authorized();

      state = const Input();

      read(startupNotipod.notifier).successfullAuthentication();
    } catch (e, st) {
      _logger.log(stateFlow, 'authenticate', e);

      if (e is DioError && e.error == 'Http status error [401]') {
        state = Input('Invalid login or password', st);
      } else {
        state = Input(e, st);
      }
    }
  }
}
