import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/chart/ui/asset_chart.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/market/market_details/helper/get_market_info.dart';
import 'package:jetwallet/features/market/market_details/store/market_news_store.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/about_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/balance_block/balance_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/cpower_block/cpower_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/deversify_portfolio_widget.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/index_allocation_block/index_allocation_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/market_info_loader_block/market_info_loader_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/market_stats_block/market_stats_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/my_balance_widget.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/price_section_widget.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/return_rates_block/return_rates_block.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/watchlist_store.dart';
import 'package:jetwallet/features/my_wallets/widgets/news_dashboard_section.dart';
import 'package:jetwallet/features/wallet/widgets/wallet_earn_section.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/prevent_duplication_events_servise.dart';

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
      key: const Key('market-details-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'market-details-screen-key',
                event: () => sAnalytics.marketAssetScreenView(asset: marketItem.symbol),
              );
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
            create: (_) => getIt.get<WatchlistStore>(),
          ),
          Provider<MarketNewsStore>(
            create: (_) => MarketNewsStore()..loadNews(marketItem.symbol),
          ),
          Provider<EarnStore>(
            create: (_) => EarnStore(),
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

  final _controller = ScrollController();

  late Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();

    marketInfo = getMarketInfo(widget.marketItem.associateAsset);

    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent) {
        final newsStore = MarketNewsStore.of(context);
        newsStore.loadMoreNews();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final chart = ChartStore.of(context);
    final watchlistIdsN = WatchlistStore.of(context);

    final currency = currencyFrom(currencies, widget.marketItem.symbol);

    var isInWatchlist = watchlistIdsN.state.contains(widget.marketItem.associateAsset);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        title: widget.marketItem.name,
        subtitle: widget.marketItem.symbol,
        rightIcon: isInWatchlist
            ? Assets.svg.medium.favourite2.simpleSvg(
                width: 24,
              )
            : Assets.svg.medium.favourite.simpleSvg(
                width: 24,
              ),
        onRightIconTap: () {
          if (isInWatchlist) {
            watchlistIdsN.removeFromWatchlist(widget.marketItem.associateAsset);
            isInWatchlist = false;
          } else {
            watchlistIdsN.addToWatchlist(widget.marketItem.associateAsset);
            isInWatchlist = true;
            sNotification.showError(
              intl.market_added_to_favorites,
              isError: false,
            );
          }
        },
        onLeftIconTap: () {
          _timer?.cancel();
          sAnalytics.tapOnTheBackButtonFromMarketAssetScreen(
            asset: widget.marketItem.symbol,
          );
          sRouter.maybePop();
        },
      ),
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PriceSectionWidget(
              marketItem: widget.marketItem,
            ),
            AssetChart(
              marketItem: widget.marketItem,
              onCandleSelected: (ChartInfoModel? chartInfo) {
                chart.updateSelectedCandle(chartInfo?.right);
              },
            ),
            BalanceBlock(
              marketItem: widget.marketItem,
            ),
            MyBalanceWidget(marketItem: widget.marketItem),
            WalletEarnSection(currency: currency),
            DeversifyPortfolioWidget(marketItem: widget.marketItem),
            ReturnRatesBlock(
              assetSymbol: widget.marketItem.associateAsset,
            ),
            const SpaceH20(),
            if (widget.marketItem.type == AssetType.indices) ...[
              IndexAllocationBlock(
                marketItem: widget.marketItem,
              ),
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
                            isCpower: widget.marketItem.symbol == 'CPWR',
                          ),
                        ],
                        const SpaceH8(),
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
            const NewsDashboardSection(),
            const SpaceH120(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 30), _onTimerComplete);
  }

  void _onTimerComplete() {
    if (mounted) {
      AnchorsHelper().addMarketDetailsAnchor(widget.marketItem.symbol);
    }
  }

  @override
  void deactivate() {
    _timer?.cancel();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    if (_timer != null) {
      if (!_timer!.isActive) {
        _startTimer();
      }
    } else {
      _startTimer();
    }
  }
}
