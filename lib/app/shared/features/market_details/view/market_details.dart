import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/components/loaders/loader.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../../../screens/market/notifier/watchlist/watchlist_notipod.dart';
import '../../chart/notifier/chart_notipod.dart';
import '../../chart/notifier/chart_union.dart';
import '../../chart/view/asset_chart.dart';
import '../../wallet/notifier/operation_history_notipod.dart';
import '../../wallet/provider/operation_history_fpod.dart';
import '../notifier/market_news_notipod.dart';
import '../provider/market_info_fpod.dart';
import '../provider/market_news_fpod.dart';
import 'components/about_block/about_block.dart';
import 'components/asset_day_change.dart';
import 'components/asset_price.dart';
import 'components/balance_block/balance_block.dart';
import 'components/index_allocation_block/index_allocation_block.dart';
import 'components/index_history_block/index_history_block.dart';
import 'components/index_overview_block/index_overview_block.dart';
import 'components/market_news_block/market_news_block.dart';
import 'components/market_stats_block/market_stats_block.dart';
import 'components/return_rates_block/return_rates_block.dart';

class MarketDetails extends HookWidget {
  const MarketDetails({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final marketInfo = useProvider(
      marketInfoFpod(
        marketItem.associateAsset,
      ),
    );
    final chartN = useProvider(chartNotipod.notifier);
    final watchlistIdsN = useProvider(watchlistIdsNotipod.notifier);
    final initTransactionHistory = useProvider(
      operationHistoryInitFpod(
        marketItem.symbol,
      ),
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        marketItem.symbol,
      ),
    );
    final newsInit = useProvider(marketNewsInitFpod(marketItem.symbol));
    final news = useProvider(marketNewsNotipod);
    final chart = useProvider(
      chartNotipod,
    );
    useProvider(watchlistIdsNotipod);

    return SPageFrame(
      header: Material(
        color: chart.union != const ChartUnion.loading()
            ? Colors.transparent
            : colors.grey5,
        child: SPaddingH24(
          child: SSmallHeader(
            title: '${marketItem.name} (${marketItem.symbol})',
            showStarButton: true,
            isStarSelected:
                watchlistIdsN.isInWatchlist(marketItem.associateAsset),
            onStarButtonTap: () {
              if (watchlistIdsN.isInWatchlist(marketItem.associateAsset)) {
                watchlistIdsN.removeFromWatchlist(marketItem.associateAsset);
              } else {
                watchlistIdsN.addToWatchlist(marketItem.associateAsset);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BalanceBlock(
        marketItem: marketItem,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (chart.union != const ChartUnion.loading())
              SizedBox(
                height: 104,
                child: Column(
                  children: [
                    AssetPrice(
                      assetId: marketItem.associateAsset,
                    ),
                    AssetDayChange(
                      assetId: marketItem.associateAsset,
                    ),
                  ],
                ),
              ),
            if (chart.union == const ChartUnion.loading())
              Container(
                height: 104,
                width: double.infinity,
                color: colors.grey5,
                child: Column(
                  children: const [
                    SpaceH17(),
                    SSkeletonTextLoader(height: 24, width: 152),
                    SpaceH10(),
                    SSkeletonTextLoader(height: 16, width: 80),
                    SpaceH37(),
                  ],
                ),
              ),
            AssetChart(
              marketItem,
              (ChartInfoModel? chartInfo) {
                chartN.updateSelectedCandle(chartInfo?.right);
              },
            ),
            initTransactionHistory.when(
              data: (data) {
                if (marketItem.type == AssetType.indices &&
                    transactionHistory.operationHistoryItems.isNotEmpty) {
                  return IndexHistoryBlock(
                    marketItem: marketItem,
                  );
                } else {
                  return const SizedBox();
                }
              },
              loading: () => const Loader(),
              error: (_, __) => const SizedBox(),
            ),
            ReturnRatesBlock(
              assetSymbol: marketItem.associateAsset,
            ),
            const SpaceH20(),
            if (marketItem.type == AssetType.indices) ...[
              IndexAllocationBlock(
                marketItem: marketItem,
              ),
              const IndexOverviewBlock(),
            ],
            marketInfo.when(
              data: (marketInfo) {
                return SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (marketInfo != null) ...[
                        if (marketItem.type != AssetType.indices) ...[
                          MarketStatsBlock(
                            marketInfo: marketInfo,
                          ),
                        ],
                        AboutBlock(
                          marketInfo: marketInfo,
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const Loader(),
              error: (_, __) => const SizedBox(),
            ),
            const SpaceH28(),
            newsInit.when(
              data: (_) {
                return MarketNewsBlock(
                  news: news.news,
                  assetId: marketItem.associateAsset,
                );
              },
              loading: () => const Loader(),
              error: (_, __) => const SizedBox(),
            ),
            const SpaceH34(),
          ],
        ),
      ),
    );
  }
}
