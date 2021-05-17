import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/authentication_model.dart';
import '../../../service/services/authentication/model/login_request_model.dart';
import '../../../service/services/authentication/model/register_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../providers/auth_screen_stpod.dart';
import '../authentication_model_notifier.dart';
import '../credentials_notifier/credentials_notifier.dart';
import '../credentials_notifier/state/credentials_state.dart';
import 'union/authentication_union.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationUnion> {
  AuthenticationNotifier({
    required this.router,
    required this.credentials,
    required this.credentialsNotifier,
    required this.authModelNotifier,
    required this.authenticationService,
    required this.storageService,
  }) : super(const Input());

  final StateController<RouterUnion> router;
  final CredentialsState credentials;
  final CredentialsNotifier credentialsNotifier;
  final AuthenticationModelNotifier authModelNotifier;
  final AuthenticationService authenticationService;
  final LocalStorageService storageService;

  Future<void> authenticate(AuthScreen authScreen) async {
    final registerModel = RegisterRequestModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    final loginModel = LoginRequestModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      state = const Loading();

      AuthenticationModel authModel;

      if (authScreen == AuthScreen.signIn) {
        authModel = await authenticationService.login(loginModel);
      } else {
        authModel = await authenticationService.register(registerModel);
      }

      authModelNotifier.state = authModel;

      await storageService.setString(tokenKey, authModel.token);

      await storageService.setString(refreshTokenKey, authModel.refreshToken);

      router.state = const Authorised();

      state = const Input();

      credentialsNotifier.clear();
    } catch (e, st) {
      state = Input(e, st);
    }
  }
}
