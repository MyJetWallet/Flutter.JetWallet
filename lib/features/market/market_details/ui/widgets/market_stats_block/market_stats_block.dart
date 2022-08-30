import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

import '../../../helper/format_number.dart';
import 'components/market_sentiment_item.dart';
import 'components/market_stats_item.dart';

class MarketStatsBlock extends StatelessWidget {
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
          height: 56,
          child: Baseline(
            baseline: 35,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              intl.marketStatsBlock_marketStats,
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
                    name: intl.marketStatsBlock_markCap,
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
                    name: intl.marketStatsBlock_circSupply,
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
