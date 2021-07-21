import 'package:flutter/material.dart';
import '../../../../model/market_item_model.dart';
import '../../market_item/market_item.dart';

class MarketList extends StatelessWidget {
  const MarketList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MarketItemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MarketItem(
          marketItem: items[index],
        );
      },
    );
  }
}
