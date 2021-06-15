import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../router/provider/router_stpod/router_union.dart';
import '../../../service/services/authentication/model/authenticate/authentication_model.dart';
import '../../../service/services/authentication/model/authenticate/login_request_model.dart';
import '../../../service/services/authentication/model/authenticate/register_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../../shared/helpers/current_platform.dart';
import '../../../shared/logging/levels.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../provider/auth_screen_stpod.dart';
import '../auth_model_notifier/auth_model_notifier.dart';
import '../credentials_notifier/credentials_notifier.dart';
import '../credentials_notifier/credentials_state.dart';
import 'authentication_union.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationUnion> {
  AuthenticationNotifier({
    required this.router,
    required this.credentialsState,
    required this.credentialsNotifier,
    required this.authModelNotifier,
    required this.authService,
    required this.storageService,
  }) : super(const Input());

  final StateController<RouterUnion> router;
  final CredentialsState credentialsState;
  final CredentialsNotifier credentialsNotifier;
  final AuthModelNotifier authModelNotifier;
  final AuthenticationService authService;
  final LocalStorageService storageService;

  static final _logger = Logger('AuthenticationNotifier');

  Future<void> authenticate(AuthScreen authScreen) async {
    _logger.log(notifier, 'authenticate');

    try {
      final loginRequest = LoginRequestModel(
        email: credentialsState.emailController.text,
        password: credentialsState.passwordController.text,
        platform: currentPlatform,
      );

      final registerRequest = RegisterRequestModel(
        email: credentialsState.emailController.text,
        password: credentialsState.passwordController.text,
        platform: currentPlatform,
      );

      state = const Loading();

      AuthenticationModel authModel;

      if (authScreen == AuthScreen.signIn) {
        authModel = await authService.login(loginRequest);
      } else {
        authModel = await authService.register(registerRequest);
      }

      await storageService.setString(refreshTokenKey, authModel.refreshToken);

      authModelNotifier.updateToken(authModel.token);
      authModelNotifier.updateRefreshToken(authModel.refreshToken);

      router.state = const Authorised();

      state = const Input();

      credentialsNotifier.clear();
    } catch (e, st) {
      _logger.log(stateFlow, 'authenticate', e);

      state = Input(e, st);
    }
  }
}
