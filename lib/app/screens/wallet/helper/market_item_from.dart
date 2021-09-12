import '../../market/model/market_item_model.dart';

MarketItemModel marketItemFrom(List<MarketItemModel> items, String symbol) {
  return items.firstWhere((item) => item.associateAsset == symbol);
}
