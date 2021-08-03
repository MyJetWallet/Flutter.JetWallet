import 'package:flutter/material.dart';
import '../../../../../market/model/market_item_model.dart';

class AssetDayChange extends StatelessWidget {
  const AssetDayChange({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          asset.isGrowing
              ? Icons.arrow_drop_up
              : Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        Text(
          '\$${asset.dayPriceChange} '
              '(${asset.dayPercentChange}%)',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
