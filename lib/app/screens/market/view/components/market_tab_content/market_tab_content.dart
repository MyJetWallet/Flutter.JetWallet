import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/header_text.dart';
import '../../../model/market_item_model.dart';
import '../../../notifier/search/search_notipod.dart';
import '../../../provider/market_stpod.dart';
import 'components/market_list.dart';
import 'components/market_reordable_list.dart';

class MarketTabContent extends HookWidget {
  const MarketTabContent({
    Key? key,
    this.watchlist = false,
    required this.items,
  }) : super(key: key);

  final List<MarketItemModel> items;
  final bool watchlist;

  @override
  Widget build(BuildContext context) {
    final market = useProvider(marketStpod);
    final search = useProvider(searchNotipod);

    if (market.state == MarketState.watch) {
      if (watchlist) {
        return const MarketReorderableList();
      } else {
        return MarketList(items: items);
      }
    } else {
      if (items.isEmpty) {
        return Center(
          child: HeaderText(
            text: 'No results for \n"${search.search}"',
            textAlign: TextAlign.center,
          ),
        );
      } else {
        if (watchlist) {
          return const MarketReorderableList();
        } else {
          return MarketList(items: items);
        }
      }
    }
  }
}
