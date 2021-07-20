import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/market_gainers_items_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_loosers_items_pod.dart';
import 'components/currency_button/currency_button.dart';
import 'components/market_app_bar.dart';

const marketTabsLength = 4;

class Market extends HookWidget {
  const Market();

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketItemsPod);
    final gainers = useProvider(marketGainersItemsPod);
    final loosers = useProvider(marketLoosersItemsPod);

    return DefaultTabController(
      length: marketTabsLength,
      child: Scaffold(
        appBar: const MarketAppBar(),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return MarketItem(marketItem: items[index]);
              },
            ),
            const Text('Watchlist'),
            ListView.builder(
              itemCount: gainers.length,
              itemBuilder: (context, index) {
                return MarketItem(marketItem: gainers[index]);
              },
            ),
            ListView.builder(
              itemCount: loosers.length,
              itemBuilder: (context, index) {
                return MarketItem(marketItem: loosers[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
