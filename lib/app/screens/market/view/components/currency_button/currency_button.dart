import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/market_item_model.dart';

import 'components/currency_card.dart';

class MarketItem extends StatelessWidget {
  const MarketItem({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: Border.all(),
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: MarketItemCard(
          marketItem: marketItem,
        ),
      ),
    );
  }
}
