import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/chart/notifier/chart_notipod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/loaders/loader.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../../../screens/market/notifier/watchlist/watchlist_notipod.dart';
import '../../chart/view/asset_chart.dart';
import '../provider/market_info_fpod.dart';
import 'components/about_block/about_block.dart';
import 'components/balance_block/balance_block.dart';
import 'components/market_details_app_bar/components/asset_day_change.dart';
import 'components/market_details_app_bar/components/asset_price.dart';
import 'components/market_news_block/market_news_block.dart';
import 'components/market_stats_block/market_stats_block.dart';
import 'components/return_rates_block/return_rates_block.dart';

class MarketDetails extends StatefulHookWidget {
  const MarketDetails({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarketDetailsState();

  final MarketItemModel marketItem;
}

class _MarketDetailsState extends State<MarketDetails>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final marketInfo = useProvider(
      marketInfoFpod(
        widget.marketItem.associateAsset,
      ),
    );
    final chartN = useProvider(chartNotipod(animationController).notifier);
    final watchlistIdsN = useProvider(watchlistIdsNotipod.notifier);
    useProvider(watchlistIdsNotipod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${widget.marketItem.name} (${widget.marketItem.id})',
          showStarButton: true,
          isStarSelected:
              watchlistIdsN.isInWatchlist(widget.marketItem.associateAsset),
          onStarButtonTap: () {
            if (watchlistIdsN.isInWatchlist(widget.marketItem.associateAsset)) {
              watchlistIdsN
                  .removeFromWatchlist(widget.marketItem.associateAsset);
            } else {
              watchlistIdsN.addToWatchlist(widget.marketItem.associateAsset);
            }
          },
        ),
      ),
      bottomNavigationBar: BalanceBlock(
        marketItem: widget.marketItem,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 104,
              child: Column(
                children: [
                  AssetPrice(
                    animationController: animationController,
                    assetId: widget.marketItem.associateAsset,
                  ),
                  AssetDayChange(
                    animationController: animationController,
                    assetId: widget.marketItem.associateAsset,
                  ),
                ],
              ),
            ),
            AssetChart(
              widget.marketItem.associateAssetPair,
              (ChartInfoModel? chartInfo) {
                // chartN.updateSelectedCandle(chartInfo?.right);
              },
            ),
            ReturnRatesBlock(
              assetSymbol: widget.marketItem.associateAsset,
            ),
            const SpaceH20(),
            marketInfo.when(
              data: (marketInfo) {
                return SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarketStatsBlock(
                        marketInfo: marketInfo,
                      ),
                      AboutBlock(
                        marketInfo: marketInfo,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Loader(),
              error: (e, _) => Text('$e'),
            ),
            const SpaceH28(),
            MarketNewsBlock(
              assetId: widget.marketItem.associateAsset,
            ),
            const SpaceH34(),
          ],
        ),
      ),
    );
  }
}
