import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/global/const.dart';
import 'package:jetwallet/screens/wallet/wallet_actions.dart';
import 'package:jetwallet/screens/wallet/wallet_models.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:redux/redux.dart';

class SignalRService {
  SignalRService(this.store);

  Store<AppState> store;

  Future<void> initSignalR() async {
    // store
    //   ..dispatch(SetAssets(AssetListModel(
    //     assets: [
    //       Asset(
    //         symbol: 'symbol1',
    //         description: 'desc1',
    //         accuracy: 0,
    //       ),
    //       Asset(
    //         symbol: 'symbol2',
    //         description: 'desc2',
    //         accuracy: 0,
    //       ),
    //       Asset(
    //         symbol: 'symbol3',
    //         description: 'desc3',
    //         accuracy: 0,
    //       ),
    //     ],
    //     now: 0,
    //   )))
    //   ..dispatch(makeAssetBalanceList())
    //   ..dispatch(SetBalances(BalanceListModel(
    //     balances: [
    //       Balance(
    //         assetId: 'symbol1',
    //         balance: 1,
    //         reserve: 1,
    //         lastUpdate: 'lastUpdate',
    //         sequenceId: 1,
    //       ),
    //       Balance(
    //         assetId: 'symbol2',
    //         balance: 2,
    //         reserve: 2,
    //         lastUpdate: 'lastUpdate',
    //         sequenceId: 2,
    //       ),
    //       Balance(
    //         assetId: 'symbol3',
    //         balance: 3,
    //         reserve: 3,
    //         lastUpdate: 'lastUpdate',
    //         sequenceId: 3,
    //       ),
    //     ],
    //   )))
    //   ..dispatch(makeAssetBalanceList());

    final hubConnection = HubConnectionBuilder()
        .withUrl(
            urlSignalR,
            HttpConnectionOptions(
              logging: (level, message) => print(message),
            ))
        .build()
          ..onclose(
              (error) => print('HubConnection: Connection closed with $error'))
          ..on(assetListMessage, (data) {
            print(data);
            store
              ..dispatch(SetAssets(AssetListModel.fromJson(data?.first)))
              ..dispatch(makeAssetBalanceList());
          })
          ..on(spotWalletBalancesMessage, (data) {
            print(data);
            store
              ..dispatch(SetBalances(BalanceListModel.fromJson(data?.first)))
              ..dispatch(makeAssetBalanceList());
          });
    await hubConnection.start();
    await hubConnection.invoke(initMessage, args: [
      'jn6WzjW7p051KkqJV2785OlWxWNxNKItyhjdeGWLSilE0dVSJTFxUZ89ZAK1QAWVp2D3yHnvsEybGpoYNTJHquhc0GNheg6z/NZM/j7CiS9oGxzCtkmv+8ZDKZd/lU9zfSvyylgA/6SQPg60AE+SH6w+13M7ECN/vyzvLod/FbppKrXy3a491vuT+Pwv+Ty2'
    ]);
  }
}
