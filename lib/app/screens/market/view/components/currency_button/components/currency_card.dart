import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../helper/format_day_percentage_change.dart';
import '../../../../model/market_item_model.dart';

class MarketItemCard extends StatelessWidget {
  const MarketItemCard({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final dayPercentageChange = formatDayPercentageChange(
      marketItem.dayPercentChange,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 14.w,
      ),
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: Image.network(marketItem.iconUrl),
          ),
          const SpaceW8(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(marketItem.name),
              Text(
                marketItem.id,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${marketItem.lastPrice}'),
              Text(
                dayPercentageChange,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
