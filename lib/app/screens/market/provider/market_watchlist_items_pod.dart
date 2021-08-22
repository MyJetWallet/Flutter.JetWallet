import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/market_item_model.dart';
import '../notifier/watchlist_notipod.dart';

import 'market_items_pod.dart';

final marketWatchlistItemsPod =
    Provider.autoDispose<List<MarketItemModel>>((ref) {
  final watchlistIds = ref.watch(watchlistNotipod);
  final items = ref.watch(marketItemsPod);
  final notifier = ref.watch(watchlistNotipod.notifier);
  final watchlistItems = items
      .where(
        (item) => notifier.isInWatchlist(item.associateAsset),
      )
      .toList();

  for (final watchlistId in watchlistIds) {
    for (final watchlistItem in watchlistItems) {
      final itemIndex = watchlistItems.indexOf(watchlistItem);
      final watchlistItemIndex = watchlistIds.indexOf(watchlistId);

      if (watchlistId == watchlistItem.associateAsset) {
        watchlistItems[itemIndex] =
            watchlistItems[itemIndex].copyWith(weight: watchlistItemIndex);
      }
    }
  }

  watchlistItems.sort((a, b) => a.weight.compareTo(b.weight));

  return watchlistItems;
});
