import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../screens/market/helper/format_day_percentage_change.dart';
import '../../../../provider/return_rates_pod.dart';
import 'return_rate_item.dart';

class ReturnRates extends HookWidget {
  const ReturnRates({
    Key? key,
    required this.assetSymbol,
  }) : super(key: key);

  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    final returnRates = useProvider(
      returnRatesPod(assetSymbol),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ReturnRateItem(
          header: 'Day',
          value: formatDayPercentageChange(returnRates.dayPrice),
        ),
        ReturnRateItem(
          header: 'Week',
          value: formatDayPercentageChange(returnRates.weekPrice),
        ),
        ReturnRateItem(
          header: 'Month',
          value: formatDayPercentageChange(returnRates.monthPrice),
        ),
        ReturnRateItem(
          header: '3 Months',
          value: formatDayPercentageChange(
            returnRates.threeMonthPrice,
          ),
        ),
      ],
    );
  }
}
