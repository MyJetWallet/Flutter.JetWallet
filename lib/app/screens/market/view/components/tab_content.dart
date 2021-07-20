import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/market_item_model.dart';
import '../../provider/market_stpod.dart';
import '../../provider/search_stpod.dart';
import 'header_text.dart';

class ItemsList extends HookWidget {
  const ItemsList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MarketItemModel> items;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(marketStpod);
    final search = useProvider(searchStpod);

    return state.state == MarketState.watch
        ? ItemsList(items: items)
        : items.isEmpty
            ? Center(
                child: HeaderText(
                  text: 'No results for \n"${search.state.text}"',
                  textAlign: TextAlign.center,
                ),
              )
            : ItemsList(items: items);
  }
}
