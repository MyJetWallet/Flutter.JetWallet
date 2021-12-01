import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/helpers/format_currency_amount.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../notifier/watchlist/watchlist_notipod.dart';
import '../../../../provider/market_watchlist_items_pod.dart';
import 'empty_watchlist.dart';

class MarketReorderableList extends HookWidget {
  const MarketReorderableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketWatchlistItemsPod);
    final notifier = useProvider(watchlistIdsNotipod.notifier);
    final baseCurrency = useProvider(baseCurrencyPod);

    if (items.isNotEmpty) {
      return ReorderableListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.only(bottom: 66.h),
        itemBuilder: (context, index) {
          final item = items[index];

          return SMarketItem(
            key: Key(
              '${items[index].weight}',
            ),
            icon: NetworkSvgW24(
              url: item.iconUrl,
            ),
            name: item.name,
            price: formatCurrencyAmount(
              prefix: baseCurrency.prefix,
              value: item.lastPrice,
              symbol: baseCurrency.symbol,
              accuracy: baseCurrency.accuracy,
            ),
            ticker: item.id,
            last: item == items.last,
            percent: item.dayPercentChange,
            onTap: () {
              navigatorPush(
                context,
                MarketDetails(
                  marketItem: item,
                ),
              );
            },
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
