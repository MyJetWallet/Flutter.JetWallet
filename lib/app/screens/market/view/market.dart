import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/market_gainers_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_loosers_pod.dart';
import '../provider/market_stpod.dart';
import 'components/market_app_bar/market_app_bar.dart';
import 'components/market_tab_content/market_tab_content.dart';
import 'components/search_app_bar/serach_app_bar.dart';

const _marketTabsLength = 4;

class Market extends HookWidget {
  const Market();

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketItemsPod);
    final gainers = useProvider(marketGainersPod);
    final loosers = useProvider(marketLoosersPod);
    final state = useProvider(marketStpod);

    return DefaultTabController(
      length: _marketTabsLength,
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
              const Text('Watchlist'),
              MarketTabContent(
                items: gainers,
              ),
              MarketTabContent(
                items: loosers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
