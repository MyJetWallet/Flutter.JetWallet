import 'package:jetwallet/screens/home/wallet/wallet_state.dart';
import 'package:jetwallet/screens/loader/loader_state.dart';
import 'package:jetwallet/screens/login/login_state.dart';
import 'package:jetwallet/screens/login/registration/registration_state.dart';
import 'package:jetwallet/screens/notifier/reducer.dart';
import 'package:jetwallet/state/config/config_state.dart';
import 'package:jetwallet/state/user/user_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  const AppState(
    this.walletState,
    this.appConfigState,
    this.loaderState,
    this.notifierState,
    this.userState,
    this.loginState,
    this.registrationState,
  );

  factory AppState.initialState() {
    return AppState(
      WalletState.empty(),
      AppConfigState.empty(),
      LoaderState.empty(),
      NotifierState.empty(),
      UserState.empty(),
      LoginState.empty(),
      RegistrationState.empty(),
    );
  }

  final WalletState walletState;
  final AppConfigState appConfigState;
  final LoaderState loaderState;
  final NotifierState notifierState;
  final UserState userState;
  final LoginState loginState;
  final RegistrationState registrationState;
}

AppState appStateReducer(AppState state, action) => AppState(
      walletReducer(state.walletState, action),
      appConfigReducer(state.appConfigState, action),
      loaderReducer(state.loaderState, action),
      notifierReducer(state.notifierState, action),
      userReducer(state.userState, action),
      loginReducer(state.loginState, action),
      registrationReducer(state.registrationState, action),
    );
