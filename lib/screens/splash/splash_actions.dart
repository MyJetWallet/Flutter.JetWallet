import 'package:redux/redux.dart';

import '../../api/model/refresh.dart';
import '../../api/spot_wallet_client.dart';
import '../../app_navigator/actions.dart';
import '../../app_state.dart';
import '../../global/const.dart';
import '../../state/config/config_storage.dart';
import '../loader/loader_actions.dart';
import '../login/registration/registration_actions.dart';

Function refreshToken(SpotWalletClient client, ConfigStorage configStorage) {
  return (Store<AppState> store) async {
    final token = await configStorage.getString(tokenKey);
    client.token = token;

    if (token != null) {
      final response = await client
          .refreshToken(RefreshBody(token, DateTime.now().toIso8601String()));
      final newToken = response.data.toString();
      if (response.result == okSuccessResult ||
          response.result == zeroSuccessResult) {
        store.dispatch(SetIsLoading(false));
        client.token = newToken;
        store.dispatch(saveUser(newToken, configStorage));
      } else {
        store
          ..dispatch(SetIsLoading(false))
          ..dispatch(PopAndPushNamed('/login'));
      }
    } else {
      store..dispatch(SetIsLoading(false))..dispatch(PopAndPushNamed('/login'));
    }
  };
}
