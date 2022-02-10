import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_indices_pod.dart';
import '../provider/market_losers_pod.dart';
import 'components/market_tab_bar_views/all_tab_bar_view.dart';
import 'components/market_tab_bar_views/gainers_tab_bar_view.dart';
import 'components/market_tab_bar_views/indices_tab_bar_view.dart';
import 'components/market_tab_bar_views/losers_tab_bar_view.dart';
import 'components/market_tab_bar_views/watchlist_tab_bar_view.dart';

class Market extends HookWidget {
  const Market({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
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
                const AllTabBarView(),
                const WatchlistTabBarView(),
                if (indices.isNotEmpty) const IndicesTabBarView(),
                if (gainers.isNotEmpty) const GainersTabBarView(),
                if (losers.isNotEmpty) const LosersTabBarView(),
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomTabs(
                tabs: [
                  const BottomTab(text: 'All'),
                  const BottomTab(text: 'Watchlist'),
                  if (indices.isNotEmpty) const BottomTab(text: 'Crypto Sets'),
                  if (gainers.isNotEmpty) const BottomTab(text: 'Gainers'),
                  if (losers.isNotEmpty) const BottomTab(text: 'Losers'),
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
