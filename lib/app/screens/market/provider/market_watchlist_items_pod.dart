import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/market_item_model.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import 'market_items_pod.dart';

final marketWatchlistItemsPod =
    Provider.autoDispose<List<MarketItemModel>>((ref) {
  final watchlistIds = ref.watch(watchlistIdsNotipod);
  final items = ref.watch(marketItemsPod);
  final watchlistIdsN = ref.watch(watchlistIdsNotipod.notifier);
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
        watchlistItems[itemIndex] =
            watchlistItems[itemIndex].copyWith(weight: watchlistItemIndex);
      }
    }
  }

  watchlistItems.sort((a, b) => a.weight.compareTo(b.weight));

  return watchlistItems;
});
