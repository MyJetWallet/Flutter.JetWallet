import 'package:injector/injector.dart';
import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_navigator/actions.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/loader/loader_actions.dart';
import 'package:jetwallet/signal_r/signal_r_service.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'package:redux/redux.dart';

Function logOut() {
  return (Store<AppState> store) async {
    store.dispatch(SetIsLoading(true));
    final client = Injector.appInstance.get<SpotWalletClient>();
    final response = await client.logOut();

    handleResponse(store, response, successHandler: () async {
      await Injector.appInstance.get<ConfigStorage>().clearAll();
      await Injector.appInstance.get<SignalRService>().disconnect();
      store.dispatch(PushNamedAndRemoveUntil('/login'));
    });
  };
}
