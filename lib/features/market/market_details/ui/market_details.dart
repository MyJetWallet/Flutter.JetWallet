import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/action_recurring_buy.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import 'package:jetwallet/features/actions/action_sell/action_sell.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/chart/ui/asset_chart.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/market/market_details/helper/get_market_info.dart';
import 'package:jetwallet/features/market/market_details/store/market_news_store.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/about_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/asset_day_change.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/asset_price.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/balance_block/balance_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/cpower_block/cpower_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/index_allocation_block/index_allocation_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/market_info_loader_block/market_info_loader_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/market_news_block/market_news_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/market_stats_block/market_stats_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/return_rates_block/return_rates_block.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/watchlist_store.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/features/reccurring/ui/recurring_buy_banner.dart';
import 'package:jetwallet/utils/helpers/supports_recurring_buy.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

class MarketDetails extends StatelessWidget {
  const MarketDetails({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChartStore>(
          create: (_) => ChartStore(
            ChartInput(
              creationDate: marketItem.startMarketTime,
              instrumentId: marketItem.associateAssetPair,
            ),
          ),
        ),
        Provider<WatchlistStore>(
          create: (_) => WatchlistStore(),
        ),
        Provider<MarketNewsStore>(
          create: (_) => MarketNewsStore()..loadNews(marketItem.symbol),
        ),
      ],
      builder: (context, child) => _MarketDetailsBody(
        marketItem: marketItem,
      ),
    );
  }
}

class _MarketDetailsBody extends StatefulObserverWidget {
  const _MarketDetailsBody({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  State<_MarketDetailsBody> createState() => _MarketDetailsBodyState();
}

class _MarketDetailsBodyState extends State<_MarketDetailsBody> {
  Future<MarketInfoResponseModel?>? marketInfo;

  @override
  void initState() {
    super.initState();

    marketInfo = getMarketInfo(widget.marketItem.associateAsset);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;

    final chart = ChartStore.of(context);
    final watchlistIdsN = WatchlistStore.of(context);

    final news = MarketNewsStore.of(context);

    final currency = currencyFrom(currencies, widget.marketItem.symbol);
    final recurringNotifier = RecurringBuysStore();

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    var isInWatchlist =
        watchlistIdsN.state.contains(widget.marketItem.associateAsset);

    final filteredRecurringBuys = recurringNotifier.recurringBuysFiltred
        .where(
          (element) => element.toAsset == currency.symbol,
        )
        .toList();

    final moveToRecurringInfo = filteredRecurringBuys.length == 1;

    final lastRecurringItem =
        filteredRecurringBuys.isNotEmpty ? filteredRecurringBuys[0] : null;

    return SPageFrame(
      header: Material(
        color: chart.union != const ChartUnion.loading()
            ? Colors.transparent
            : colors.grey5,
        child: SPaddingH24(
          child: SSmallHeader(
            title: '${widget.marketItem.name} (${widget.marketItem.symbol})',
            showStarButton: true,
            isStarSelected: isInWatchlist,
            onStarButtonTap: () {
              if (isInWatchlist) {
                watchlistIdsN
                    .removeFromWatchlist(widget.marketItem.associateAsset);
                isInWatchlist = false;
              } else {
                watchlistIdsN.addToWatchlist(widget.marketItem.associateAsset);
                isInWatchlist = true;
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BalanceBlock(
        marketItem: widget.marketItem,
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
                      marketItem: widget.marketItem,
                    ),
                    AssetDayChange(
                      marketItem: widget.marketItem,
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
                    SSkeletonTextLoader(
                      height: 24,
                      width: 152,
                    ),
                    SpaceH10(),
                    SSkeletonTextLoader(
                      height: 16,
                      width: 80,
                    ),
                    SpaceH37(),
                  ],
                ),
              ),
            AssetChart(
              marketItem: widget.marketItem,
              onCandleSelected: (ChartInfoModel? chartInfo) {
                chart.updateSelectedCandle(chartInfo?.right);
              },
            ),
            ReturnRatesBlock(
              assetSymbol: widget.marketItem.associateAsset,
            ),
            const SpaceH20(),
            const SDivider(),
            const SpaceH2(),
            if (widget.marketItem.type == AssetType.indices) ...[
              IndexAllocationBlock(
                marketItem: widget.marketItem,
              ),
              // const IndexOverviewBlock(),
            ],
            FutureBuilder<MarketInfoResponseModel?>(
              future: marketInfo,
              builder: (context, marketInfo) {
                if (marketInfo.hasData) {
                  return SPaddingH24(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (marketInfo.data != null) ...[
                          if (widget.marketItem.type != AssetType.indices) ...[
                            const SpaceH20(),
                            MarketStatsBlock(
                              marketInfo: marketInfo.data!,
                              isCPower: widget.marketItem.symbol == 'CPWR',
                            ),
                          ],
                          AboutBlock(
                            marketInfo: marketInfo.data!,
                            showDivider: news.news.isNotEmpty,
                            isCpower: widget.marketItem.symbol == 'CPWR',
                          ),
                        ],
                      ],
                    ),
                  );
                } else if (marketInfo.hasData) {
                  return const SizedBox();
                } else {
                  return const MarketInfoLoaderBlock();
                }
              },
            ),
            if (widget.marketItem.symbol == 'CPWR') ...[
              const SPaddingH24(
                child: CpowerBlock(),
              ),
            ],
            if (widget.marketItem.symbol != 'CPWR') ...[
              if (news.isNewsLoaded) ...[
                MarketNewsBlock(
                  news: news.news,
                  assetId: widget.marketItem.associateAsset,
                ),
              ] else ...[
                SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SpaceH40(),
                      SSkeletonTextLoader(
                        height: 16,
                        width: 133,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
