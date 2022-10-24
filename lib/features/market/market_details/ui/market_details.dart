import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
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
    Key? key,
    required this.marketItem,
  }) : super(key: key);

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

class _MarketDetailsBody extends StatelessObserverWidget {
  const _MarketDetailsBody({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final marketInfo = getMarketInfo(marketItem.associateAsset);

    final chart = ChartStore.of(context);
    final watchlistIdsN = WatchlistStore.of(context);

    final news = MarketNewsStore.of(context);

    final currency = currencyFrom(currencies, marketItem.symbol);
    final recurringNotifier = RecurringBuysStore();

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    var isInWatchlist = watchlistIdsN.state.contains(marketItem.associateAsset);

    final filteredRecurringBuys = recurringNotifier.recurringBuys
        .where(
          (element) => element.toAsset == currency.symbol,
        )
        .toList();

    final moveToRecurringInfo = filteredRecurringBuys.length == 1;

    final lastRecurringItem =
        filteredRecurringBuys.isNotEmpty ? filteredRecurringBuys[0] : null;

    sAnalytics.assetView(marketItem.name);

    return SPageFrame(
      header: Material(
        color: chart.union != const ChartUnion.loading()
            ? Colors.transparent
            : colors.grey5,
        child: SPaddingH24(
          child: SSmallHeader(
            title: '${marketItem.name} (${marketItem.symbol})',
            showStarButton: true,
            isStarSelected: isInWatchlist,
            onStarButtonTap: () {
              if (isInWatchlist) {
                watchlistIdsN.removeFromWatchlist(marketItem.associateAsset);
                isInWatchlist = false;
              } else {
                sAnalytics.addToWatchlist(marketItem.name);
                watchlistIdsN.addToWatchlist(marketItem.associateAsset);
                isInWatchlist = true;
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
                      marketItem: marketItem,
                    ),
                    AssetDayChange(
                      marketItem: marketItem,
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
              marketItem: marketItem,
              onCandleSelected: (ChartInfoModel? chartInfo) {
                chart.updateSelectedCandle(chartInfo?.right);
              },
            ),
            ReturnRatesBlock(
              assetSymbol: marketItem.associateAsset,
            ),
            const SpaceH40(),
            if (supportsRecurringBuy(marketItem.symbol, currencies))
              RecurringBuyBanner(
                title: recurringNotifier.recurringBannerTitle(
                  asset: currency.symbol,
                  context: context,
                ),
                type: recurringNotifier.type(currency.symbol),
                topMargin: 0,
                onTap: () {
                  // Todo: need refactor
                  if (kycState.depositStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    if (recurringNotifier.activeOrPausedType(currency.symbol)) {
                      if (moveToRecurringInfo && lastRecurringItem != null) {
                        sRouter.push(
                          ShowRecurringInfoActionRouter(
                            recurringItem: lastRecurringItem,
                            assetName: currency.description,
                          ),
                        );
                      } else {
                        showRecurringBuyAction(
                          context: context,
                          currency: currency,
                          total: recurringNotifier.totalRecurringByAsset(
                            asset: currency.symbol,
                          ),
                        );
                      }
                    } else {
                      var dismissWasCall = false;
                      showActionWithoutRecurringBuy(
                        title: intl.recurringBuysName_empty,
                        context: context,
                        onItemTap: (RecurringBuysType type) {
                          sRouter.navigate(
                            CurrencyBuyRouter(
                              currency: currency,
                              fromCard: false,
                              recurringBuysType: type,
                            ),
                          );
                        },
                        onDissmis: () => {
                          dismissWasCall = true,
                          sAnalytics.closeRecurringBuySheet(
                            currency.description,
                            Source.marketScreen,
                          ),
                        },
                        then: (val) => {
                          if (val == null && !dismissWasCall)
                            {
                              sAnalytics.closeRecurringBuySheet(
                                currency.description,
                                Source.marketScreen,
                              ),
                            },
                        },
                      );
                    }
                  } else {
                    sAnalytics.setupRecurringBuyView(
                      currency.description,
                      Source.assetScreen,
                    );

                    kycAlertHandler.handle(
                      status: kycState.depositStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () => showSellAction(context),
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
                    );
                  }
                },
              ),
            if (marketItem.type == AssetType.indices) ...[
              IndexAllocationBlock(
                marketItem: marketItem,
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
                          if (marketItem.type != AssetType.indices) ...[
                            const SpaceH20(),
                            MarketStatsBlock(
                              marketInfo: marketInfo.data!,
                            ),
                          ],
                          AboutBlock(
                            marketInfo: marketInfo.data!,
                            showDivider: news.news.isNotEmpty,
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
            if (news.isNewsLoaded) ...[
              MarketNewsBlock(
                news: news.news,
                assetId: marketItem.associateAsset,
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
        ),
      ),
    );
  }
}
