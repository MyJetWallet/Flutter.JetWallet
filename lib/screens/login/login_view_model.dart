import 'package:redux/redux.dart';

import '../../api/spot_wallet_client.dart';
import '../../app_navigator/actions.dart';
import '../../app_state.dart';
import '../../state/config/config_storage.dart';
import 'login_actions.dart';

class LoginViewModel {
  LoginViewModel({
    required this.onSignUpPress,
    required this.onSignInPress,
    required this.setEmail,
    required this.setPassword,
    required this.setIsPasswordVisible,
    required this.appVersion,
    required this.email,
    required this.emailError,
    required this.password,
    required this.appBuildNumber,
    required this.isSignInEnabled,
    required this.isPasswordVisible,
  });

  factory LoginViewModel.fromStore(Store<AppState> store) {
    final email = store.state.loginState.email;
    final password = store.state.loginState.password;
    final isPasswordVisible =
        store.state.loginState.isPasswordVisible && password.isNotEmpty;

    return LoginViewModel(
      onSignUpPress: () => store.dispatch(PushNamed('/registration')),
      onSignInPress: (client, configStorage, email, password) =>
          store.dispatch(authenticate(client, configStorage, email, password)),
      setEmail: (email) => store.dispatch(SetEmail(email)),
      setPassword: (password) => store.dispatch(SetPassword(password)),
      setIsPasswordVisible: () => store.dispatch(SetIsPasswordVisible()),
      appVersion: store.state.appConfigState.appVersion,
      email: email,
      emailError: store.state.loginState.emailError,
      password: password,
      appBuildNumber: store.state.appConfigState.appBuildNumber,
      isSignInEnabled: email.isNotEmpty && password.isNotEmpty,
      isPasswordVisible: isPasswordVisible,
    );
  }

  final void Function() onSignUpPress;
  final void Function(
          SpotWalletClient, ConfigStorage, String email, String password)
      onSignInPress;
  final void Function(String) setEmail;
  final void Function(String) setPassword;
  final void Function() setIsPasswordVisible;
  final String email;
  final String emailError;
  final String password;
  final String appVersion;
  final String appBuildNumber;
  final bool isSignInEnabled;
  final bool isPasswordVisible;
}
