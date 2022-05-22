import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../../shared/providers/service_providers.dart';
import '../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_indices_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_losers_pod.dart';
import 'components/market_tab_bar_views/components/market_nested_scroll_view.dart';
import 'components/market_tab_bar_views/watchlist_tab_bar_view.dart';

class Market extends HookWidget {
  const Market({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
    final allItems = useProvider(marketItemsPod);
    final indices = useProvider(marketIndicesPod);
    final gainers = useProvider(marketGainersPod);
    final losers = useProvider(marketLosersPod);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      losers.isEmpty,
      indices.isEmpty,
    );

    return Scaffold(
      body: DefaultTabController(
        length: marketTabsLength,
        child: Stack(
          children: [
            TabBarView(
              children: [
                MarketNestedScrollView(
                  items: allItems,
                  showBanners: true,
                  sourceScreen: FilterMarketTabAction.all,
                ),
                const WatchlistTabBarView(),
                if (indices.isNotEmpty)
                  MarketNestedScrollView(
                    items: indices,
                    sourceScreen: FilterMarketTabAction.cryptoSets,
                  ),
                if (gainers.isNotEmpty)
                  MarketNestedScrollView(
                    items: gainers,
                    sourceScreen: FilterMarketTabAction.gainers,
                  ),
                if (losers.isNotEmpty)
                  MarketNestedScrollView(
                    items: losers,
                    sourceScreen: FilterMarketTabAction.losers,
                  ),
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomTabs(
                tabs: [
                  BottomTab(text: intl.market_all),
                  BottomTab(text: intl.market_bottomTabLabel2),
                  if (indices.isNotEmpty)
                    BottomTab(
                      text: intl.market_bottomTabLabel3,
                    ),
                  if (gainers.isNotEmpty)
                    BottomTab(
                      text: intl.market_bottomTabLabel4,
                    ),
                  if (losers.isNotEmpty)
                    BottomTab(
                      text: intl.market_bottomTabLabel5,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _marketTabsLength(
    bool gainersEmpty,
    bool losersEmpty,
    bool indicesEmpty,
  ) {
    var marketTabsLength = 5;

    if (gainersEmpty) {
      marketTabsLength--;
    }
    if (losersEmpty) {
      marketTabsLength--;
    }
    if (indicesEmpty) {
      marketTabsLength--;
    }

    return marketTabsLength;
  }
}
