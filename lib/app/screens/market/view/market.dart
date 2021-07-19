import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/gainers_market_items_pod.dart';
import '../provider/loosers_market_items_pod.dart';
import '../provider/market_items_pod.dart';
import 'components/currency_button/currency_button.dart';
import 'components/header_text.dart';
import 'components/market_tab.dart';
import 'components/search_button.dart';

const marketTabsLength = 4;

class Market extends HookWidget {
  const Market();

  @override
  Widget build(BuildContext context) {
    final marketItems = useProvider(marketItemsPod);
    final gainersMarketItems = useProvider(gainersMarketItemsPod);
    final loosersMarketItems = useProvider(loosersMarketItemsPod);

    return DefaultTabController(
      length: marketTabsLength,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              HeaderText(
                text: 'Market',
              ),
              SearchButton(),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                ),
                margin: EdgeInsets.only(bottom: 16.h),
                child: const TabBar(
                  indicator: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabs: [
                    MarketTab(text: 'All'),
                    MarketTab(text: 'Watchlist'),
                    MarketTab(text: 'Gainers'),
                    MarketTab(text: 'Loosers'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: marketItems.length,
              itemBuilder: (context, index) {
                return MarketItem(marketItem: marketItems[index]);
              },
            ),
            const Text('Watchlist'),
            ListView.builder(
              itemCount: gainersMarketItems.length,
              itemBuilder: (context, index) {
                return MarketItem(marketItem: gainersMarketItems[index]);
              },
            ),
            ListView.builder(
              itemCount: loosersMarketItems.length,
              itemBuilder: (context, index) {
                return MarketItem(marketItem: loosersMarketItems[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
