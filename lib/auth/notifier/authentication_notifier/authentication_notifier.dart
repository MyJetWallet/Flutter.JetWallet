import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/provider/union/router_union.dart';
import '../../../service/services/authentication/model/authenticate/authentication_model.dart';
import '../../../service/services/authentication/model/authenticate/login_request_model.dart';
import '../../../service/services/authentication/model/authenticate/register_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../../shared/helpers/current_platform.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../provider/auth_screen_stpod.dart';
import '../auth_model_notifier.dart';
import '../credentials_notifier/credentials_notifier.dart';
import '../credentials_notifier/state/credentials_state.dart';
import 'union/authentication_union.dart';

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

  Future<void> authenticate(AuthScreen authScreen) async {
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

    try {
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
      state = Input(e, st);
    }
  }
}
