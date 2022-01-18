import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_indices_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_losers_pod.dart';
import 'components/fade_on_scroll.dart';
import 'components/market_banners/market_banners.dart';
import 'components/market_tab_content/market_tab_content.dart';

class Market extends HookWidget {
  Market({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
    final colors = useProvider(sColorPod);
    final items = useProvider(marketItemsPod);
    final indices = useProvider(marketIndicesPod);
    final gainers = useProvider(marketGainersPod);
    final losers = useProvider(marketLosersPod);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      losers.isEmpty,
      indices.isEmpty,
    );

    return DefaultTabController(
      length: marketTabsLength,
      child: Scaffold(
        backgroundColor: colors.white,
        body: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    backgroundColor: colors.white,
                    pinned: true,
                    elevation: 0,
                    expandedHeight: 160,
                    collapsedHeight: 120,
                    primary: false,
                    flexibleSpace: FadeOnScroll(
                      scrollController: _scrollController,
                      fullOpacityOffset: 50,
                      fadeInWidget: const SDivider(
                        width: double.infinity,
                      ),
                      fadeOutWidget: const SPaddingH24(
                        child: SMarketHeader(
                          title: 'Market',
                          percent: 1.73,
                          isPositive: true,
                          subtitle: 'Market is up',
                        ),
                      ),
                      permanentWidget: const SMarketHeaderClosed(
                        title: 'Market',
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const MarketBanners(),
                      MarketTabContent(
                        items: items,
                      ),
                    ],
                  ),
                  const MarketTabContent(
                    items: [],
                    watchlist: true,
                  ),
                  if (indices.isNotEmpty)
                    MarketTabContent(
                      items: indices,
                    ),
                  if (gainers.isNotEmpty)
                    MarketTabContent(
                      items: gainers,
                    ),
                  if (losers.isNotEmpty)
                    MarketTabContent(
                      items: losers,
                    ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomTabs(
                tabs: [
                  const BottomTab(text: 'All'),
                  const BottomTab(text: 'Watchlist'),
                  if (indices.isNotEmpty) ...[
                    const BottomTab(text: 'Crypto Indices'),
                  ],
                  if (gainers.isNotEmpty) ...[
                    const BottomTab(text: 'Gainers'),
                  ],
                  if (losers.isNotEmpty) ...[
                    const BottomTab(text: 'Losers'),
                  ],
                ],
              ),
            )
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
