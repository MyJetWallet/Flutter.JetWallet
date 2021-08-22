import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../market/view/components/header_text.dart';
import '../../../helper/format_number.dart';
import 'components/market_stats_item.dart';
import 'components/market_stats_table_cell.dart';

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
        const HeaderText(
          text: 'Market Stats',
          textAlign: TextAlign.start,
        ),
        const SpaceH15(),
        Table(
          children: [
            TableRow(
              children: [
                MarketStatsTableCell(
                  padding: EdgeInsets.only(right: 8.w),
                  child: MarketStatsItem(
                    name: 'Mark cap',
                    value: '\$${formatNumber(marketInfo.marketCap)}',
                  ),
                ),
                MarketStatsTableCell(
                  padding: EdgeInsets.only(left: 8.w),
                  child: MarketStatsItem(
                    name: 'Circ supply',
                    value: formatNumber(marketInfo.supply),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                MarketStatsTableCell(
                  padding: EdgeInsets.only(right: 8.w),
                  child: MarketStatsItem(
                    name: 'Vol (24h)',
                    value: '\$${formatNumber(marketInfo.dayVolume)}',
                  ),
                ),
                MarketStatsTableCell(
                  padding: EdgeInsets.only(left: 8.w),
                  child: const MarketStatsItem(
                    name: 'Santimentos',
                    value: '50%/50%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
