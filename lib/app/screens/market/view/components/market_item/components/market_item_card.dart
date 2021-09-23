import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../../shared/helpers/format_asset_price_value.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../helper/format_day_percentage_change.dart';
import '../../../../model/market_item_model.dart';

class MarketItemCard extends HookWidget {
  const MarketItemCard({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final dayPercentageChange = formatDayPercentageChange(
      marketItem.dayPercentChange,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 14.w,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
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
          AssetIcon(
            imageUrl: marketItem.iconUrl,
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
              Text(
                formatPriceValue(
                  prefix: baseCurrency.prefix,
                  value: marketItem.lastPrice,
                  accuracy: baseCurrency.accuracy,
                ),
              ),
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
