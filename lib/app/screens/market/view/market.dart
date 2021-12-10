import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_losers_pod.dart';
import 'components/fade_on_scroll.dart';
import 'components/market_banner/market_banner.dart';
import 'components/market_tab_content/market_tab_content.dart';
import 'components/market_tabs/market_tabs.dart';

class Market extends HookWidget {
  Market({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
    final colors = useProvider(sColorPod);
    final items = useProvider(marketItemsPod);
    final gainers = useProvider(marketGainersPod);
    final losers = useProvider(marketLosersPod);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      losers.isEmpty,
    );

    return DefaultTabController(
      length: marketTabsLength,
      child: Scaffold(
        backgroundColor: colors.white,
        body: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    pinned: true,
                    elevation: 0,
                    expandedHeight: 160.h,
                    collapsedHeight: 120.h,
                    primary: false,
                    flexibleSpace: FadeOnScroll(
                      scrollController: _scrollController,
                      fullOpacityOffset: 50,
                      fadeInWidget: const SDivider(
                        width: double.infinity,
                      ),
                      fadeOutWidget: SPaddingH24(
                        child: SMarketHeader(
                          title: 'Market',
                          percent: 1.73,
                          isPositive: true,
                          subtitle: 'Market is up',
                          onSearchButtonTap: () {},
                        ),
                      ),
                      permanentWidget: SMarketHeaderClosed(
                        title: 'Market',
                        onSearchButtonTap: () {},
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
                      const MarketBanner(),
                      MarketTabContent(
                        items: items,
                      ),
                    ],
                  ),
                  const MarketTabContent(
                    items: [],
                    watchlist: true,
                  ),
                  if (gainers.isNotEmpty) ...[
                    MarketTabContent(
                      items: gainers,
                    ),
                  ],
                  if (losers.isNotEmpty) ...[
                    MarketTabContent(
                      items: losers,
                    ),
                  ],
                ],
              ),
            ),
            const Align(
              alignment: FractionalOffset.bottomCenter,
              child: MarketTabs(),
            )
          ],
        ),
      ),
    );
  }

  int _marketTabsLength(bool gainersEmpty, bool losersEmpty) {
    var marketTabsLength = 4;

    if (gainersEmpty) {
      marketTabsLength--;
    }
    if (losersEmpty) {
      marketTabsLength--;
    }

    return marketTabsLength;
  }
}
