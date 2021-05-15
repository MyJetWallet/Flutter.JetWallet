import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/providers/router_stpod.dart';
import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/login_request_model.dart';
import '../../../service/services/authentication/model/register_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../providers/auth_screen_stpod.dart';
import '../../providers/authentication_model_stpod.dart';
import '../../providers/credentials_notipod.dart';
import 'union/authentication_union.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationUnion> {
  AuthenticationNotifier({
    required this.read,
    required this.authenticationService,
  }) : super(const Input());

  final Reader read;
  final AuthenticationService authenticationService;

  Future<AsyncValue<void>> authenticate(AuthScreen authScreen) async {
    if (authScreen == AuthScreen.signIn) {
      return _login();
    } else {
      return _register();
    }
  }

  Future<AsyncValue<void>> _register() async {
    final credentials = read(credentialsNotipod);
    final router = read(routerStpod);

    final model = RegisterRequestModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      state = const Loading();

      final authModel = await authenticationService.register(model);

      read(authenticationModelStpod).state = authModel;

      await LocalStorageService().setString(tokenKey, authModel.token);

      await LocalStorageService().setString(
        refreshTokenKey,
        authModel.refreshToken,
      );

      router.state = const Authorised();

      state = const Input();

      return const AsyncValue.data(null);
    } catch (e, st) {
      state = Input(e, st);
      router.state = const Unauthorised();
      return AsyncValue.error(e, st);
    }
  }

  Future<AsyncValue<void>> _login() async {
    final credentials = read(credentialsNotipod);
    final router = read(routerStpod);

    final model = LoginRequestModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      state = const Loading();

      final authModel = await authenticationService.login(model);

      read(authenticationModelStpod).state = authModel;

      await LocalStorageService().setString(tokenKey, authModel.token);

      await LocalStorageService().setString(
        refreshTokenKey,
        authModel.refreshToken,
      );

      router.state = const Authorised();

      state = const Input();

      return const AsyncValue.data(null);
    } catch (e, st) {
      state = Input(e, st);
      router.state = const Unauthorised();
      return AsyncValue.error(e, st);
    }
  }
}
