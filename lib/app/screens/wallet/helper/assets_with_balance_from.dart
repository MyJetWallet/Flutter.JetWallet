import '../../market/model/market_item_model.dart';

/// Value can't be null because this function is invoked on the screens where
/// at least one asset with balance exists.
List<MarketItemModel> assetsWithBalanceFrom(List<MarketItemModel> assets) {
  return assets.where((asset) => !asset.isBalanceEmpty).toList();
}
