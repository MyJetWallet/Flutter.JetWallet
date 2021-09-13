import '../../market/model/market_item_model.dart';

/// Value can't be null because symbol is taken from items
MarketItemModel marketItemFrom(List<MarketItemModel> items, String symbol) {
  return items.firstWhere((item) => item.associateAsset == symbol);
}
