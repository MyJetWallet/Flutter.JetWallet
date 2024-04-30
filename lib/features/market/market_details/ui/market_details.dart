import 'package:auto_route/auto_route.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/chart/ui/asset_chart.dart';
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
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/di/di.dart';
import '../../../../utils/formatting/base/volume_format.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/navigate_to_wallet.dart';

@RoutePage(name: 'MarketDetailsRouter')
class MarketDetails extends StatelessWidget {
  const MarketDetails({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('market-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          sAnalytics.marketAssetScreenView(asset: marketItem.symbol);
        }
      },
      child: MultiProvider(
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
      ),
    );
  }
}

class _MarketDetailsBody extends StatefulObserverWidget {
  const _MarketDetailsBody({
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

    var isInWatchlist = watchlistIdsN.state.contains(widget.marketItem.associateAsset);

    final baseCurrency = sSignalRModules.baseCurrency;

    void onMarketItemTap({
      required BuildContext context,
      required CurrencyModel currency,
    }) {
      navigateToWallet(context, currency);
    }

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: Material(
        color: chart.union != const ChartUnion.loading() ? Colors.transparent : colors.white,
        child: SPaddingH24(
          child: SSmallHeader(
            title: '${widget.marketItem.name} (${widget.marketItem.symbol})',
            showStarButton: true,
            isStarSelected: isInWatchlist,
            onStarButtonTap: () {
              if (isInWatchlist) {
                watchlistIdsN.removeFromWatchlist(widget.marketItem.associateAsset);
                isInWatchlist = false;
              } else {
                watchlistIdsN.addToWatchlist(widget.marketItem.associateAsset);
                isInWatchlist = true;
              }
            },
            onBackButtonTap: () {
              sAnalytics.tapOnTheBackButtonFromMarketAssetScreen(asset: widget.marketItem.symbol);
              sRouter.maybePop();
            },
          ),
        ),
      ),
      bottomNavigationBar: BalanceBlock(
        marketItem: widget.marketItem,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Material(
                  color: colors.white,
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
                            child: const Column(
                              children: [
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
                                    const SpaceH46(),
                                  ],
                                ),
                              );
                            } else if (!marketInfo.hasData) {
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
                            const SPaddingH24(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                        const SpaceH53(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 347,
            left: 24,
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.grey4,
                ),
              ),
              child: Material(
                color: colors.white,
                borderRadius: BorderRadius.circular(16),
                child: SWalletItem(
                  isRounded: true,
                  currencyPrefix: baseCurrency.prefix,
                  currencySymbol: baseCurrency.symbol,
                  decline: widget.marketItem.dayPercentChange.isNegative,
                  icon: SNetworkSvg24(
                    url: widget.marketItem.iconUrl,
                  ),
                  primaryText: intl.portfolioHeader_balance,
                  amount: getIt<AppStore>().isBalanceHide
                      ? '**** ${baseCurrency.symbol}'
                      : volumeFormat(
                          decimal: widget.marketItem.baseBalance,
                          symbol: baseCurrency.symbol,
                          accuracy: baseCurrency.accuracy,
                        ),
                  amountDecimal: double.parse('${widget.marketItem.baseBalance}'),
                  secondaryText: getIt<AppStore>().isBalanceHide
                      ? '******* ${widget.marketItem.symbol}'
                      : volumeFormat(
                          decimal: widget.marketItem.assetBalance,
                          symbol: widget.marketItem.symbol,
                          accuracy: widget.marketItem.assetAccuracy,
                        ),
                  onTap: () {
                    sAnalytics.tapOnTheBalanceButtonOnMarketAssetScreen(asset: widget.marketItem.symbol);
                    onMarketItemTap(
                      context: context,
                      currency: currency,
                    );
                  },
                  removeDivider: true,
                  leftBlockTopPadding: widget.marketItem.isBalanceEmpty ? 30 : 20,
                  rightBlockTopPadding: 20,
                  showSecondaryText: !widget.marketItem.isBalanceEmpty,
                  fullSizeBalance: true,
                  hideBalance: getIt<AppStore>().isBalanceHide,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
