import 'package:jetwallet/screens/wallet/wallet_models.dart';
import 'package:jetwallet/screens/wallet/wallet_actions.dart';
import 'package:redux/redux.dart';

class WalletState {
  WalletState({
    required this.assetListModel,
    required this.balanceListModel,
    required this.assetBalanceList,
  });

  factory WalletState.empty() => WalletState(
        assetListModel: null,
        balanceListModel: null,
        assetBalanceList: [],
      );

  final AssetListModel? assetListModel;
  final BalanceListModel? balanceListModel;
  final List<AssetBalance> assetBalanceList;

  AssetBalance getOrCreateAssetBalance(String symbol) {
    for (var element in assetBalanceList) {
      if (element.symbol == symbol) {
        return element;
      }
    }
    var element = AssetBalance(description: symbol, balance: 0, symbol: symbol);
    assetBalanceList.add(element);
    return element;
  }

  WalletState copyWith({
    AssetListModel? assetListModel,
    BalanceListModel? balanceListModel,
    List<AssetBalance>? assetBalanceList,
  }) {
    return WalletState(
      assetListModel: assetListModel ?? this.assetListModel,
      balanceListModel: balanceListModel ?? this.balanceListModel,
      assetBalanceList: assetBalanceList ?? this.assetBalanceList,
    );
  }
}

WalletState setAssets(
  WalletState state,
  SetAssets action,
) {
  return state.copyWith(assetListModel: action.assets);
}

WalletState setBalances(
    WalletState state,
    SetBalances action,
    ) {
  return state.copyWith(balanceListModel: action.balances);
}

WalletState setAssetBalancesList(
    WalletState state,
    SetAssetBalanceList action,
    ) {

  return state.copyWith(assetBalanceList: action.assetBalanceList);
}

Reducer<WalletState> walletReducer = combineReducers<WalletState>([
  TypedReducer<WalletState, SetAssets>(setAssets),
  TypedReducer<WalletState, SetBalances>(setBalances),
  TypedReducer<WalletState, SetAssetBalanceList>(setAssetBalancesList),
]);