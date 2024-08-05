import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/store/market_filter_store.dart';
import 'package:jetwallet/features/market/ui/widgets/market_not_loaded.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helper/crypto_filer_modal.dart';
import '../../../../helper/crypto_search_modal.dart';
import '../../../../model/market_item_model.dart';
import '../../fade_on_scroll.dart';
import '../helper/reset_market_scroll_position.dart';
import 'market_header_stats.dart';

enum MarketShowType { crypto, nft }

class MarketNestedScrollView extends StatelessWidget {
  const MarketNestedScrollView({
    super.key,
    this.showBanners = false,
    this.showFilter = false,
    this.showSearch = false,
    required this.marketShowType,
    required this.sourceScreen,
  });

  final MarketShowType marketShowType;

  final bool showBanners;
  final bool showFilter;
  final bool showSearch;
  final FilterMarketTabAction sourceScreen;

  @override
  Widget build(BuildContext context) {
    return Provider<MarketFilterStore>(
      create: (context) => MarketFilterStore(),
      builder: (context, child) => _MarketNestedScrollViewBody(
        showFilter: showFilter,
        showSearch: showSearch,
        sourceScreen: sourceScreen,
        marketShowType: marketShowType,
      ),
    );
  }
}

class _MarketNestedScrollViewBody extends StatefulObserverWidget {
  const _MarketNestedScrollViewBody({
    this.showFilter = false,
    this.showSearch = false,
    required this.marketShowType,
    required this.sourceScreen,
  });

  final bool showFilter;
  final bool showSearch;
  final FilterMarketTabAction sourceScreen;
  final MarketShowType marketShowType;

  @override
  State<_MarketNestedScrollViewBody> createState() => __MarketNestedScrollViewBodyState();
}

class __MarketNestedScrollViewBodyState extends State<_MarketNestedScrollViewBody> {
  final ScrollController controller = ScrollController();
  ScrollController marketScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      resetMarketScrollPosition(
        context,
        MarketFilterStore.of(context).cryptoList.length,
        controller,
      );
    });

    getIt<EventBus>().on<ResetScrollMarket>().listen((event) {
      marketScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    marketScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final colors = sKit.colors;
    final store = MarketFilterStore.of(context);

    //final showPreloader = store.cryptoList.isNotEmpty;
    final showPreloader = sSignalRModules.initFinished;

    return NestedScrollView(
      controller: controller,
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 140,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: controller,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: showPreloader
                  ? MarketHeaderStats(
                      activeFilters: store.activeFilter == 'all' ? 0 : 1,
                      onFilterButtonTap: widget.showFilter
                          ? () {
                              showCryptoFilterModalSheet(
                                context,
                                store as MarketFilterStore,
                              );
                            }
                          : null,
                      onSearchButtonTap: widget.marketShowType == MarketShowType.crypto
                          ? () {
                              showCryptoSearch(context);
                            }
                          : null,
                    )
                  : const MarketHeaderSkeletonStats(),
              permanentWidget: SMarketHeaderClosed(
                title: intl.marketNestedScrollView_market,
              ),
            ),
          ),
        ];
      },
      body: showPreloader
          ? ColoredBox(
              color: colors.white,
              child: showCryptoList(baseCurrency),
            )
          : const MarketNotLoaded(),
    );
  }

  Widget showCryptoList(BaseCurrencyModel baseCurrency) {
    final store = MarketFilterStore.of(context);

    return CustomRefreshIndicator(
      offsetToArmed: 75,
      onRefresh: () => getIt.get<SignalRService>().forceReconnectSignalR(),
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Opacity(
              opacity: !controller.isIdle ? 1 : 0,
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? _) {
                  return SizedBox(
                    height: 75,
                    child: Container(
                      width: 24.0,
                      decoration: BoxDecoration(
                        color: sKit.colors.grey5,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const RiveAnimation.asset(
                        loadingAnimationAsset,
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * 75),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
      child: ListView(
        padding: EdgeInsets.zero,
        physics: store.isReordable ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
        controller: marketScrollController,
        children: [
          if (store.watchListFiltred.isNotEmpty) ...[
            MarketSeparator(text: intl.favorites),
            ImplicitlyAnimatedReorderableList<MarketItemModel>(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              items: store.watchListFiltred,
              onReorderFinished: (item, from, to, newItems) {
                store.syncWatchListLocal(
                  newItems.map((e) => e.symbol).toList(),
                  needUpdate: true,
                );
              },
              areItemsTheSame: (a, b) => a == b,
              itemBuilder: (context, itemAnimation, item, index) {
                /*final isInWatchlist = store.watchListLocal.contains(
                  store.cryptoListFiltred[index].associateAsset,
                );*/
                const isInWatchlist = true;

                return Reorderable(
                  key: ValueKey(item),
                  builder: (context, dragAnimation, inDrag) => AnimatedBuilder(
                    animation: dragAnimation,
                    builder: (BuildContext context, Widget? _) {
                      return SizeFadeTransition(
                        sizeFraction: 0.7,
                        curve: Curves.easeInOut,
                        animation: itemAnimation,
                        child: Handle(
                          delay: const Duration(milliseconds: 100),
                          child: SMarketItem(
                            key: Key(
                              item.associateAsset,
                            ),
                            showFavoriteIcon: true,
                            isStarActive: isInWatchlist,
                            onStarButtonTap: () {
                              if (isInWatchlist) {
                                HapticFeedback.lightImpact();

                                store.removeFromWatchlist(
                                  item.associateAsset,
                                );
                              }
                            },
                            icon: SNetworkSvg24(
                              url: item.iconUrl,
                            ),
                            name: item.name,
                            price: item.lastPrice.toFormatSum(
                              symbol: baseCurrency.symbol,
                              accuracy: item.priceAccuracy,
                            ),
                            ticker: item.symbol,
                            last: !store.watchListFiltred.isNotEmpty || item == store.watchListFiltred.last,
                            percent: item.dayPercentChange,
                            onTap: () {
                              sAnalytics.tapOnTheAnyAssetOnMarketList(
                                asset: item.symbol,
                              );
                              sRouter.push(
                                MarketDetailsRouter(
                                  marketItem: item,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SpaceH20(),
          ],
          MarketSeparator(text: intl.assets),
          ImplicitlyAnimatedList<MarketItemModel>(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            items: store.cryptoFiltred,
            areItemsTheSame: (a, b) => a == b,
            itemBuilder: (context, animation, item, _) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOut,
                animation: animation,
                child: SMarketItem(
                  key: Key(
                    item.associateAsset,
                  ),
                  showFavoriteIcon: true,
                  onStarButtonTap: () {
                    HapticFeedback.lightImpact();

                    store.addToWatchlist(
                      item.associateAsset,
                    );
                  },
                  icon: SNetworkSvg24(
                    url: item.iconUrl,
                  ),
                  name: item.name,
                  price: item.lastPrice.toFormatSum(
                    symbol: baseCurrency.symbol,
                    accuracy: item.priceAccuracy,
                  ),
                  ticker: item.symbol,
                  last: item == store.cryptoListFiltred.last,
                  percent: item.dayPercentChange,
                  onTap: () {
                    sAnalytics.tapOnTheAnyAssetOnMarketList(asset: item.symbol);
                    sRouter.push(
                      MarketDetailsRouter(
                        marketItem: item,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
