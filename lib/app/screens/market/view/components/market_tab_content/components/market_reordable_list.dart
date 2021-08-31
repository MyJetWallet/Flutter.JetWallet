import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../notifier/watchlist_notipod.dart';
import '../../../../provider/market_watchlist_items_pod.dart';
import '../../market_item/market_item.dart';
import 'empty_watchlist.dart';

class MarketReorderableList extends HookWidget {
  const MarketReorderableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketWatchlistItemsPod);
    final notifier = useProvider(watchlistIdsNotipod.notifier);

    if (items.isNotEmpty) {
      return ReorderableListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return MarketItem(
            key: Key(
              '${items[index].weight}',
            ),
            marketItem: items[index],
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          notifier.changePosition(oldIndex, newIndex);
        },
      );
    } else {
      return const EmptyWatchlist();
    }
  }
}
