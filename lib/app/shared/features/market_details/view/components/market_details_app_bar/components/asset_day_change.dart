import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';

import '../../../../../wallet/helper/market_item_from.dart';

class AssetDayChange extends HookWidget {
  const AssetDayChange({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );

    return Row(
      children: [
        Icon(
          marketItem.isGrowing ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        Text(
          '\$${marketItem.dayPriceChange} '
              '(${marketItem.dayPercentChange}%)',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
