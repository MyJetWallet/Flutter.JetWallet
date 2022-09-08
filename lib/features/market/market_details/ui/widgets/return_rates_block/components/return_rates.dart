import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/helper/format_day_percentage_change.dart';
import 'package:jetwallet/features/market/market_details/model/return_rates_model.dart';
import 'package:simple_kit/simple_kit.dart';

import 'return_rate_item.dart';

class ReturnRates extends StatelessObserverWidget {
  const ReturnRates({
    Key? key,
    required this.assetSymbol,
    this.returnRates,
  }) : super(key: key);

  final String assetSymbol;
  final ReturnRatesModel? returnRates;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (returnRates != null) ...[
          ReturnRateItem(
            header: intl.returnRates_day,
            value: formatDayPercentageChange(returnRates!.dayPrice),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
        if (returnRates != null) ...[
          ReturnRateItem(
            header: intl.returnRateItem_week,
            value: formatDayPercentageChange(returnRates!.weekPrice),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
        if (returnRates != null) ...[
          ReturnRateItem(
            header: intl.returnRateItem_month,
            value: formatDayPercentageChange(returnRates!.monthPrice),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
        if (returnRates != null) ...[
          ReturnRateItem(
            header: '3 ${intl.returnRates_months}',
            value: formatDayPercentageChange(
              returnRates!.threeMonthPrice,
            ),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
      ],
    );
  }
}
