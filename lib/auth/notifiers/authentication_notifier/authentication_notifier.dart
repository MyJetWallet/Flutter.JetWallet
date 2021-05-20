import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/authentication_model.dart';
import '../../../service/services/authentication/model/login_request_model.dart';
import '../../../service/services/authentication/model/register_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../../service/services/authorization/model/authorization_request_model.dart';
import '../../../service/services/authorization/service/authorization_service.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../providers/auth_screen_stpod.dart';
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
    required this.authenticationService,
    required this.authorizationService,
    required this.storageService,
  }) : super(const Input());

  final StateController<RouterUnion> router;
  final CredentialsState credentialsState;
  final CredentialsNotifier credentialsNotifier;
  final AuthModelNotifier authModelNotifier;
  final AuthenticationService authenticationService;
  final AuthorizationService authorizationService;
  final LocalStorageService storageService;

  Future<void> authenticate(AuthScreen authScreen) async {
    final loginRequest = LoginRequestModel(
      email: credentialsState.emailController.text,
      password: credentialsState.passwordController.text,
    );

    final registerRequest = RegisterRequestModel(
      email: credentialsState.emailController.text,
      password: credentialsState.passwordController.text,
    );

    try {
      state = const Loading();

      AuthenticationModel authenticationModel;

      if (authScreen == AuthScreen.signIn) {
        authenticationModel = await authenticationService.login(loginRequest);
      } else {
        authenticationModel = await authenticationService.register(
          registerRequest,
        );
      }

      final authorizationRequest = AuthorizationRequestModel(
        authToken: authenticationModel.token,
        publicKeyPem: 'string',
      );

      final authorizationModel = await authorizationService.authorize(
        authorizationRequest,
      );

      await storageService.setString(tokenKey, authorizationModel.token);

      authModelNotifier.updateToken(authorizationModel.token);

      router.state = const Authorised();

      state = const Input();

      credentialsNotifier.clear();
    } catch (e, st) {
      state = Input(e, st);
    }
  }
}
