import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_navigator/actions.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/login/registration/registration_actions.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'package:redux/redux.dart';

class RegistrationViewModel {
  RegistrationViewModel({
    required this.onRegisterPress,
    required this.setEmail,
    required this.setPassword,
    required this.setRepeatPassword,
    required this.setIsPasswordVisible,
    required this.setIsRepeatPasswordVisible,
    required this.onCancelPress,
    required this.email,
    required this.password,
    required this.repeatPassword,
    required this.isPasswordVisible,
    required this.isRepeatPasswordVisible,
    required this.isPasswordsMatch,
    required this.isSignUpEnabled,
  });

  factory RegistrationViewModel.fromStore(Store<AppState> store) {
    final email = store.state.registrationState.email;
    final password = store.state.registrationState.password;
    final repeatPassword = store.state.registrationState.repeatPassword;
    final isPasswordVisible =
        store.state.registrationState.isPasswordVisible && password.isNotEmpty;
    final isRepeatPasswordVisible =
        store.state.registrationState.isRepeatPasswordVisible &&
            password.isNotEmpty;
    final isSignUpEnabled =
        email.isNotEmpty && password.isNotEmpty && repeatPassword.isNotEmpty;

    return RegistrationViewModel(
      onRegisterPress: (client, configStorage, email, password) =>
          store.dispatch(register(client, configStorage, email, password)),
      setEmail: (email) => store.dispatch(SetEmail(email)),
      setPassword: (password) => store.dispatch(SetPassword(password)),
      setRepeatPassword: (password) =>
          store.dispatch(SetRepeatPassword(password)),
      setIsPasswordVisible: () => store.dispatch(SetIsPasswordVisible()),
      setIsRepeatPasswordVisible: () =>
          store.dispatch(SetIsRepeatPasswordVisible()),
      onCancelPress: () => store.dispatch(Pop()),
      email: email,
      password: password,
      repeatPassword: repeatPassword,
      isPasswordVisible: isPasswordVisible,
      isRepeatPasswordVisible: isRepeatPasswordVisible,
      isPasswordsMatch: password == repeatPassword,
      isSignUpEnabled: isSignUpEnabled,
    );
  }

  final void Function(SpotWalletClient, ConfigStorage, String, String)
      onRegisterPress;
  final void Function(String) setEmail;
  final void Function(String) setPassword;
  final void Function(String) setRepeatPassword;
  final void Function() setIsPasswordVisible;
  final void Function() setIsRepeatPasswordVisible;
  final void Function() onCancelPress;
  final String email;
  final String password;
  final String repeatPassword;
  final bool isPasswordVisible;
  final bool isRepeatPasswordVisible;
  final bool isPasswordsMatch;
  final bool isSignUpEnabled;
}
