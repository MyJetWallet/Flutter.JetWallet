import 'package:jetwallet/screens/wallet/wallet_state.dart';
import 'package:jetwallet/state/config/config_state.dart';

class AppState {
  AppState(
    this.walletState,
    this.appConfigState,
  );

  AppState.initialState() {
    walletState = WalletState.empty();
    appConfigState = AppConfigState.empty();
  }

  late WalletState walletState;
  late AppConfigState appConfigState;
}

AppState appStateReducer(AppState state, action) => AppState(
      walletReducer(state.walletState, action),
      appConfigReducer(state.appConfigState, action),
    );
