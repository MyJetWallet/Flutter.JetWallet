import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/home/wallet/wallet_models.dart';
import 'package:redux/redux.dart';

class WalletViewModel {
  WalletViewModel({required this.assets, required this.assetBalanceList});

  factory WalletViewModel.fromStore(Store<AppState> store) {
    return WalletViewModel(
      assets: store.state.walletState.assetListModel?.assets ?? [],
      assetBalanceList: store.state.walletState.assetBalanceList,
    );
  }

  final List<Asset> assets;
  final List<AssetBalance> assetBalanceList;
}
