import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_loosers_pod.dart';
import '../provider/market_stpod.dart';
import 'components/market_app_bar/market_app_bar.dart';
import 'components/market_tab_content/market_tab_content.dart';
import 'components/search_app_bar/serach_app_bar.dart';

class Market extends HookWidget {
  const Market();

  @override
  Widget build(BuildContext context) {
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
    final items = useProvider(marketItemsPod);
    final gainers = useProvider(marketGainersPod);
    final loosers = useProvider(marketLoosersPod);
    final state = useProvider(marketStpod);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      loosers.isEmpty,
    );

    return DefaultTabController(
      length: marketTabsLength,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: state.state == MarketState.search
            ? const SearchAppBar()
            : const MarketAppBar() as PreferredSizeWidget,
        body: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: TabBarView(
            children: [
              MarketTabContent(
                items: items,
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
              if (loosers.isNotEmpty) ...[
                MarketTabContent(
                  items: loosers,
                ),
              ],
            ],
          ),
        ),
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
