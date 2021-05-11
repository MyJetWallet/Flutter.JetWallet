import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/home/wallet/wallet_models.dart';
import 'package:redux/redux.dart';

class SetAssets {
  SetAssets(this.assets);

  final AssetListModel? assets;
}

class SetBalances {
  SetBalances(this.balances);

  final BalanceListModel? balances;
}

class SetAssetBalanceList {
  SetAssetBalanceList(this.assetBalanceList);

  final List<AssetBalance> assetBalanceList;
}

Function makeAssetBalanceList() {
  return (Store<AppState> store) async {
    final balances = store.state.walletState.balanceListModel?.balances;
    final assets = store.state.walletState.assetListModel?.assets;
    final assetBalanceList = <AssetBalance>[];
    final balancesAssertsIds = <String>[];

    balances?.forEach((balance) {
      balancesAssertsIds.add(balance.assetId);
    });

    assets?.forEach((asset) {
      balances?.forEach((balance) {
        if (asset.symbol == balance.assetId) {
          assetBalanceList.add(AssetBalance(
            symbol: asset.symbol,
            description: asset.description,
            balance: balance.balance,
          ));
        }
      });
    });

    assets?.forEach((asset) {
      if (!balancesAssertsIds.contains(asset.symbol)) {
        assetBalanceList.add(AssetBalance(
          symbol: asset.symbol,
          description: asset.description,
          balance: 0,
        ));
      }
    });
    assetBalanceList.sort((a1, a2) => a1.symbol.compareTo(a2.symbol));

    store.dispatch(SetAssetBalanceList(assetBalanceList));
  };
}

Function handleAssets(AssetListModel assetListModel) {
  return (Store<AppState> store) async {
    final assetBalanceList = store.state.walletState.assetBalanceList;
    // final assetBalanceList = <AssetBalance>[];
    final balancesAssertsIds = <String>[];

    assetListModel.assets.forEach((assetDto) {
      var element =
          store.state.walletState.getOrCreateAssetBalance(assetDto.symbol);
      element.symbol = assetDto.symbol;
      //todo change to icon
      element.icon = assetDto.symbol;
    });

    assetBalanceList.sort((a1, a2) => a1.symbol.compareTo(a2.symbol));

    store.dispatch(SetAssetBalanceList(assetBalanceList));
  };
}
