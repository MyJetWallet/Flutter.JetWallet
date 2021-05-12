import 'package:redux/redux.dart';
import 'package:signalr_core/signalr_core.dart';

import '../app_state.dart';
import '../global/const.dart';
import '../screens/home/wallet/wallet_actions.dart';
import '../screens/home/wallet/wallet_models.dart';

class SignalRService {
  SignalRService(this.store) {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
          // HttpConnectionOptions(
          //   logging: (level, message) => print(message),
          // ),
        )
        .build();
  }

  Store<AppState> store;
  late HubConnection _hubConnection;

  Future<void> init(String token) async {
    _hubConnection
      ..onclose(
          (error) => print('HubConnection: Connection closed with $error'))
      ..on(assetListMessage, (data) {
        store
          ..dispatch(SetAssets(AssetListModel.fromJson(data?.first)))
          ..dispatch(makeAssetBalanceList());
      })
      ..on(spotWalletBalancesMessage, (data) {
        store
          ..dispatch(SetBalances(BalanceListModel.fromJson(data?.first)))
          ..dispatch(makeAssetBalanceList());
      });
    await _hubConnection.start();
    await _hubConnection.invoke(initMessage, args: [token]);
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
  }
}
