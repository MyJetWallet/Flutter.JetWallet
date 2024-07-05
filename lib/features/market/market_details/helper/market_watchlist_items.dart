import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/watchlist_store.dart';

List<MarketItemModel> marketWatchlistItems() {
  final watchlistIds = sSignalRModules.keyValue.watchlist?.value ?? <String>[];
  final items = sSignalRModules.getMarketPrices;
  final watchlistIdsN = WatchlistStore();
  final watchlistItems = items
      .where(
        (item) => watchlistIdsN.isInWatchlist(item.associateAsset),
      )
      .toList();

  for (final id in watchlistIds) {
    for (final item in watchlistItems) {
      final itemIndex = watchlistItems.indexOf(item);
      final watchlistItemIndex = watchlistIds.indexOf(id);

      if (id == item.associateAsset) {
        watchlistItems[itemIndex] = watchlistItems[itemIndex].copyWith(weight: watchlistItemIndex);
      }
    }
  }

  watchlistItems.sort((a, b) => a.weight.compareTo(b.weight));

  return watchlistItems;
}
