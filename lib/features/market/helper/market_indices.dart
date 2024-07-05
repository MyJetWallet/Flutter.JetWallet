import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

List<MarketItemModel> getMarketIndices() {
  try {
    final items = sSignalRModules.getMarketPrices;
    final indices = items.where((item) => item.type == AssetType.indices).toList();

    return indices;
  } catch (e) {
    return [];
  }
}
