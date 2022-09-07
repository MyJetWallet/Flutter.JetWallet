import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';

List<MarketItemModel> getMarketGainers() {
  final items = sSignalRModules.getMarketPrices;
  final gainers = items.where((item) => item.dayPercentChange > 0).toList();

  gainers.sort((a, b) => b.dayPercentChange.compareTo(a.dayPercentChange));

  return gainers;
}
