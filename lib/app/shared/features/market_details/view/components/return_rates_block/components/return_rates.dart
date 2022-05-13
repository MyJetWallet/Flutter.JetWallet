import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/providers/service_providers.dart';
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
    final intl = useProvider(intlPod);
    final returnRates = useProvider(
      returnRatesPod(assetSymbol),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ReturnRateItem(
          header: intl.day,
          value: formatDayPercentageChange(returnRates.dayPrice),
        ),
        ReturnRateItem(
          header: intl.week,
          value: formatDayPercentageChange(returnRates.weekPrice),
        ),
        ReturnRateItem(
          header: intl.month,
          value: formatDayPercentageChange(returnRates.monthPrice),
        ),
        ReturnRateItem(
          header: '3 ${intl.months}',
          value: formatDayPercentageChange(
            returnRates.threeMonthPrice,
          ),
        ),
      ],
    );
  }
}
