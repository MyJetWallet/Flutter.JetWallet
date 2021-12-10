import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../helper/format_number.dart';
import 'components/market_sentiment_item.dart';
import 'components/market_stats_item.dart';

class MarketStatsBlock extends HookWidget {
  const MarketStatsBlock({
    Key? key,
    required this.marketInfo,
  }) : super(key: key);

  final MarketInfoResponseModel marketInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56.h,
          child: Baseline(
            baseline: 50.h,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'Market Stats',
              textAlign: TextAlign.start,
              style: sTextH4Style,
            ),
          ),
        ),
        Table(
          children: [
            TableRow(
              children: [
                TableCell(
                  child: MarketStatsItem(
                    name: 'Mark cap',
                    value: '\$${formatNumber(marketInfo.marketCap)}',
                  ),
                ),
                TableCell(
                  child: MarketStatsItem(
                    name: 'Vol (24h)',
                    value: '\$${formatNumber(marketInfo.dayVolume)}',
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: MarketStatsItem(
                    name: 'Circ supply',
                    value: formatNumber(marketInfo.supply),
                  ),
                ),
                const TableCell(
                  child: MarketSentimentItem(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
