import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/model/return_rates_model.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';

import 'return_rate_item.dart';

class ReturnRates extends StatelessWidget {
  const ReturnRates({
    super.key,
    required this.assetSymbol,
    this.returnRates,
  });

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
            value: returnRates!.dayPrice.toFormatPercentPriceChange(),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
        if (returnRates != null) ...[
          ReturnRateItem(
            header: intl.returnRateItem_week,
            value: returnRates!.weekPrice.toFormatPercentPriceChange(),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
        if (returnRates != null) ...[
          ReturnRateItem(
            header: intl.returnRateItem_month,
            value: returnRates!.monthPrice.toFormatPercentPriceChange(),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
        if (returnRates != null) ...[
          ReturnRateItem(
            header: '3 ${intl.returnRates_months}',
            value: returnRates!.threeMonthPrice.toFormatPercentPriceChange(),
          ),
        ] else ...[
          const ReturnRateItemSketelon(),
        ],
      ],
    );
  }
}
