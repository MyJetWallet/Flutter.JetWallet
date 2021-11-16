import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../../../shared/features/market_details/view/market_details.dart';
import '../../../shared/helpers/format_currency_amount.dart';
import '../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_loosers_pod.dart';
import 'components/fade_on_scroll.dart';
import 'components/market_tabs/market_tabs.dart';

class Market extends HookWidget {
  Market({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
    final items = useProvider(marketItemsPod);
    final gainers = useProvider(marketGainersPod);
    final loosers = useProvider(marketLoosersPod);
    // final state = useProvider(marketStpod);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      loosers.isEmpty,
    );
    final baseCurrency = useProvider(baseCurrencyPod);

    return DefaultTabController(
      length: marketTabsLength,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
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
                fadeInChild: SMarketHeaderClosed(
                  title: 'Market',
                  onSearchButtonTap: () {},
                ),
                fadeOutChild: SPaddingH24(
                  child: SMarketHeader(
                    title: 'Market',
                    percent: 1.73,
                    isPositive: true,
                    subtitle: 'Market is up',
                    onSearchButtonTap: () {},
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = items[index];

                  return SMarketItem(
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
                childCount: items.length,
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MarketTabs(),
      ),
    );
  }

  int _marketTabsLength(bool gainersEmpty, bool loosersEmpty) {
    var marketTabsLength = 4;

    if (gainersEmpty) {
      marketTabsLength--;
    }
    if (loosersEmpty) {
      marketTabsLength--;
    }

    return marketTabsLength;
  }
}
