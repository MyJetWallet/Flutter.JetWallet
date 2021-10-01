import '../../../../screens/market/model/market_item_model.dart';

/// Value can't be null because this function is invoked on the screens
/// [Wallet] where at least one asset with balance exists. On other screens
/// can throw: BadStateException.
List<MarketItemModel> marketItemsWithBalanceFrom(
  List<MarketItemModel> assets,
  String? assetId,
) {
  final marketItemsWithBalance =
      assets.where((asset) => !asset.isBalanceEmpty).toList();
  final marketItem = marketItemsWithBalance
      .firstWhere((item) => item.associateAsset == assetId);

  marketItemsWithBalance.removeWhere((item) => item.associateAsset == assetId);
  marketItemsWithBalance.insert(0, marketItem);

  return marketItemsWithBalance;
}
