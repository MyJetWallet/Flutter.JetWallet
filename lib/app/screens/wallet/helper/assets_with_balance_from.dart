import '../../market/model/market_item_model.dart';

List<MarketItemModel> assetsWithBalanceFrom(List<MarketItemModel> assets) {
  return assets.where((asset) => !asset.isBalanceEmpty).toList();
}