import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../../../../../shared/providers/service_providers.dart';
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
    final intl = useProvider(intlPod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: Baseline(
            baseline: 35,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              intl.marketStats,
              textAlign: TextAlign.start,
              style: sTextH4Style,
            ),
          ),
        ),
        const SpaceH6(),
        Table(
          children: [
            TableRow(
              children: [
                TableCell(
                  child: MarketStatsItem(
                    name: intl.markCap,
                    value: '\$${formatNumber(marketInfo.marketCap.toDouble())}',
                  ),
                ),
                TableCell(
                  child: MarketStatsItem(
                    name: '${intl.vol} (24${intl.h})',
                    value: '\$${formatNumber(marketInfo.dayVolume.toDouble())}',
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: MarketStatsItem(
                    name: intl.circSupply,
                    value: formatNumber(marketInfo.supply.toDouble()),
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
