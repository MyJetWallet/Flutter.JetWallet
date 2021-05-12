import 'package:injector/injector.dart';
import 'package:redux/redux.dart';

import '../../../api/spot_wallet_client.dart';
import '../../../app_navigator/actions.dart';
import '../../../app_state.dart';
import '../../../signal_r/signal_r_service.dart';
import '../../../state/config/config_storage.dart';
import '../../loader/loader_actions.dart';

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
