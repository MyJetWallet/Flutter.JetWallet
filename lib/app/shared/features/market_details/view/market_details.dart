import 'package:charts/entity/chart_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/loader.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../chart/notifier/chart_notipod.dart';
import '../../chart/view/asset_chart.dart';
import '../provider/market_info_fpod.dart';
import 'components/about_block/about_block.dart';
import 'components/balance_block/balance_block.dart';
import 'components/market_details_app_bar/market_details_app_bar.dart';
import 'components/market_stats_block/market_stats_block.dart';
import 'components/news_block/news_block.dart';
import 'components/return_rates_block/return_rates_block.dart';

class MarketDetails extends HookWidget {
  const MarketDetails({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final marketInfo = useProvider(
      marketInfoFpod(
        marketItem.associateAsset,
      ),
    );
    final chartN = useProvider(chartNotipod.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MarketDetailsAppBar(
          marketItem: marketItem,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 0.35.sh,
                  child: AssetChart(
                    marketItem.associateAssetPair,
                    (ChartInfo? chartInfo) {
                      chartN.updateSelectedCandle(chartInfo?.right);
                    },
                  ),
                ),
                const SpaceH15(),
                ReturnRatesBlock(
                  assetSymbol: marketItem.associateAsset,
                ),
                const SpaceH15(),
                marketInfo.when(
                  data: (marketInfo) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarketStatsBlock(
                          marketInfo: marketInfo,
                        ),
                        AboutBlock(
                          marketInfo: marketInfo,
                        ),
                      ],
                    );
                  },
                  loading: () => const Loader(),
                  error: (e, _) => Text('$e'),
                ),
                const SpaceH15(),
                NewsBlock(
                  assetId: marketItem.associateAsset,
                ),
                const SpaceH30(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BalanceBlock(
          marketItem: marketItem,
        ),
      ),
    );
  }
}
