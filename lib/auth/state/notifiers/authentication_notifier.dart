import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/state/providers/router_stpod.dart';
import '../../../router/state/union/router_union.dart';
import '../../../shared/services/local_storage_service.dart';
import '../../model/login_model.dart';
import '../../model/register_model.dart';
import '../../source/repository/auth_repository.dart';
import '../providers/auth_model_stpod.dart';
import '../providers/auth_screen_stpod.dart';
import '../providers/credentials_notipod.dart';

class AuthenticationNotifier extends StateNotifier<void> {
  AuthenticationNotifier(this.read) : super(null);

  final Reader read;

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

    final model = RegisterModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      final authModel = await AuthRepository.register(model);

      print(authModel.toString());

      read(authModelStpod).state = authModel;

      await LocalStorageService.setString(tokenKey, authModel.token);

      router.state = const Authorised();
      return const AsyncValue.data(null);
    } catch (e, st) {
      router.state = const Unauthorised();
      return AsyncValue.error(e, st);
    }
  }

  Future<AsyncValue<void>> _login() async {
    final credentials = read(credentialsNotipod);
    final router = read(routerStpod);

    final model = LoginModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      final authModel = await AuthRepository.login(model);

      print(authModel.toString());

      read(authModelStpod).state = authModel;

      await LocalStorageService.setString(tokenKey, authModel.token);

      read(routerStpod).state = const Authorised();
      return const AsyncValue.data(null);
    } catch (e, st) {
      router.state = const Unauthorised();
      return AsyncValue.error(e, st);
    }
  }
}
