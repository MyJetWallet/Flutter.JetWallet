import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/market_item_model.dart';
import '../../../provider/market_stpod.dart';
import '../../../provider/search_stpod.dart';
import '../header_text.dart';
import 'components/market_list.dart';
import 'components/market_reordable_list.dart';

class MarketTabContent extends HookWidget {
  const MarketTabContent({
    Key? key,
    required this.items,
    this.isWatchlist = false,
  }) : super(key: key);

  final List<MarketItemModel> items;
  final bool isWatchlist;

  @override
  Widget build(BuildContext context) {
    final market = useProvider(marketStpod);
    final search = useProvider(searchStpod);

    if (market.state == MarketState.watch) {
      if (isWatchlist) {
        return const MarketReorderableList();
      } else {
        return MarketList(items: items);
      }
    } else {
      if (items.isEmpty) {
        return Center(
          child: HeaderText(
            text: 'No results for \n"${search.state.text}"',
            textAlign: TextAlign.center,
          ),
        );
      } else {
        if (isWatchlist) {
          return const MarketReorderableList();
        } else {
          return MarketList(items: items);
        }
      }
    }
  }
}
