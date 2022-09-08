import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';

List<MarketItemModel> getMarketLosers() {
  try {
    final items = sSignalRModules.getMarketPrices;
    final losers = items.where((item) => item.dayPercentChange < 0).toList();

    losers.sort((a, b) => a.dayPercentChange.compareTo(b.dayPercentChange));

    return losers;
  } catch (e) {
    return [];
  }
}
