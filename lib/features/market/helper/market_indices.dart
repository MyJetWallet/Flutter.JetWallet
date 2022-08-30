import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

List<MarketItemModel> getMarketIndices() {
  final items = sSignalRModules.marketItems;
  final indices =
      items.where((item) => item.type == AssetType.indices).toList();

  return indices;
}
