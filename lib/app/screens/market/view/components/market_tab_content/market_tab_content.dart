import 'package:flutter/material.dart';

import '../../../model/market_item_model.dart';
import 'components/market_list.dart';
import 'components/market_reordable_list.dart';

class MarketTabContent extends StatelessWidget {
  const MarketTabContent({
    Key? key,
    this.watchlist = false,
    required this.items,
  }) : super(key: key);

  final List<MarketItemModel> items;
  final bool watchlist;

  @override
  Widget build(BuildContext context) {
    if (watchlist) {
      return const MarketReorderableList();
    } else {
      return MarketList(items: items);
    }
  }
}
