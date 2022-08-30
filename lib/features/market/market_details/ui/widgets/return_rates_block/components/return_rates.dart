import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/helper/format_day_percentage_change.dart';

import 'return_rate_item.dart';

class ReturnRates extends StatelessObserverWidget {
  const ReturnRates({
    Key? key,
    required this.assetSymbol,
  }) : super(key: key);

  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    final returnRates = sSignalRModules.getReturnRates(assetSymbol);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ReturnRateItem(
          header: intl.returnRates_day,
          value: formatDayPercentageChange(returnRates.dayPrice),
        ),
        ReturnRateItem(
          header: intl.returnRateItem_week,
          value: formatDayPercentageChange(returnRates.weekPrice),
        ),
        ReturnRateItem(
          header: intl.returnRateItem_month,
          value: formatDayPercentageChange(returnRates.monthPrice),
        ),
        ReturnRateItem(
          header: '3 ${intl.returnRates_months}',
          value: formatDayPercentageChange(
            returnRates.threeMonthPrice,
          ),
        ),
      ],
    );
  }
}
