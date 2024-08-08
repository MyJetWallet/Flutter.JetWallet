import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/market_watchlist_items.dart';
import 'package:jetwallet/features/market/store/watchlist_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketReorderableList extends StatelessObserverWidget {
  const MarketReorderableList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = marketWatchlistItems();
    final store = WatchlistStore();

    final baseCurrency = sSignalRModules.baseCurrency;
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.white,
      child: ReorderableListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.only(bottom: 66),
        itemBuilder: (context, index) {
          final item = items[index];

          return SMarketItem(
            key: Key(
              '${items[index].weight}',
            ),
            icon: SNetworkSvg24(
              url: item.iconUrl,
            ),
            name: item.name,
            price: item.lastPrice.toFormatSum(
              symbol: baseCurrency.symbol,
              accuracy: item.priceAccuracy,
            ),
            ticker: item.symbol,
            last: item == items.last,
            percent: item.dayPercentChange,
            onTap: () {
              sRouter.push(
                MarketDetailsRouter(
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

          store.changePosition(oldIndex, newIndex);
        },
      ),
    );
  }
}
