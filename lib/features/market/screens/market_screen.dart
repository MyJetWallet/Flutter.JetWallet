import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/invest/stores/chart/invest_chart_store.dart';
import 'package:jetwallet/features/invest/ui/widgets/small_chart.dart';
import 'package:jetwallet/features/market/helper/show_add_assets_bottom_sheet.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/store/market_instruments_lists_store.dart';
import 'package:jetwallet/features/market/store/watchlist_store.dart';
import 'package:jetwallet/features/market/widgets/add_assets_banner_widget.dart';
import 'package:jetwallet/features/market/widgets/market_sector_item_widget.dart';
import 'package:jetwallet/features/market/widgets/top_movers_market_section.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/table/divider/simple_divider.dart' as divider;
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/di/di.dart';
import '../../../core/services/prevent_duplication_events_servise.dart';

@RoutePage(name: 'MarketRouter')
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late final ScrollController _controller;

  bool isReorderingMod = false;

  bool isScroolStarted = false;

  @override
  void initState() {
    _controller = ScrollController();

    _controller.addListener(
      () {
        if (_controller.offset > 0 && !isScroolStarted) {
          setState(() {
            isScroolStarted = true;
          });
        } else if (_controller.offset <= 0 && isScroolStarted) {
          setState(() {
            isScroolStarted = false;
          });
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final chartStore = getIt.get<InvestChartStore>();

    return VisibilityDetector(
      key: const Key('market-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'market-screen-key',
                event: sAnalytics.marketListScreenView,
              );
        }
      },
      child: MultiProvider(
        providers: [
          Provider<MarketInstrumentsListsStore>(
            create: (_) => MarketInstrumentsListsStore(),
            dispose: (context, store) => store.dispose(),
          ),
          Provider<WatchlistStore>(create: (_) => getIt.get<WatchlistStore>()),
        ],
        builder: (context, child) {
          final listsStore = MarketInstrumentsListsStore.of(context);
          final watchlistIdsN = WatchlistStore.of(context);

          return SPageFrame(
            loaderText: '',
            header: AnimatedCrossFade(
              firstChild: GlobalBasicAppBar(
                title: intl.marketHeaderStats_market,
                hasLeftIcon: false,
                hasRightIcon: false,
              ),
              secondChild: SimpleLargeAltAppbar(
                title: intl.marketHeaderStats_market,
                showLabelIcon: false,
                hasRightIcon: false,
                hasTopPart: false,
              ),
              crossFadeState: isScroolStarted ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
            ),
            child: Observer(
              builder: (context) {
                final baseCurrency = sSignalRModules.baseCurrency;
                final sectors = sSignalRModules.marketSectors;

                final watchListMarketItems = watchlistIdsN.watchListMarketItems;

                final activeAssetsList = listsStore.activeMarketTab == MarketTab.favorites
                    ? watchListMarketItems
                    : listsStore.activeAssetsList;

                final list = reorderingItems(watchListMarketItems, context);

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  slivers: [
                    if (sectors.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: STableHeader(
                          title: intl.market_sectors,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverGrid.builder(
                          itemCount: sectors.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisExtent: 112,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 4.0,
                          ),
                          itemBuilder: (context, index) {
                            return MarketSectorItemWidget(
                              sector: sectors[index],
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 32),
                      ),
                    ],
                    const SliverToBoxAdapter(
                      child: TopMoversMarketSection(),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      sliver: SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 8,
                          children: [
                            STagButton(
                              lable: intl.market_favorites,
                              state: listsStore.activeMarketTab == MarketTab.favorites
                                  ? TagButtonState.selected
                                  : TagButtonState.defaultt,
                              onTap: () {
                                setState(() {
                                  isReorderingMod = false;
                                });
                                listsStore.setActiveMarketTab(MarketTab.favorites);
                              },
                            ),
                            STagButton(
                              lable: intl.market_all,
                              state: listsStore.activeMarketTab == MarketTab.all
                                  ? TagButtonState.selected
                                  : TagButtonState.defaultt,
                              onTap: () {
                                setState(() {
                                  isReorderingMod = false;
                                });
                                listsStore.setActiveMarketTab(MarketTab.all);
                              },
                            ),
                            STagButton(
                              lable: intl.market_bottomTabLabel4,
                              state: listsStore.activeMarketTab == MarketTab.gainers
                                  ? TagButtonState.selected
                                  : TagButtonState.defaultt,
                              onTap: () {
                                setState(() {
                                  isReorderingMod = false;
                                });
                                listsStore.setActiveMarketTab(MarketTab.gainers);
                              },
                            ),
                            STagButton(
                              lable: intl.market_bottomTabLabel5,
                              state: listsStore.activeMarketTab == MarketTab.lossers
                                  ? TagButtonState.selected
                                  : TagButtonState.defaultt,
                              onTap: () {
                                setState(() {
                                  isReorderingMod = false;
                                });
                                listsStore.setActiveMarketTab(MarketTab.lossers);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isReorderingMod)
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 16),
                        sliver: SliverToBoxAdapter(
                          child: SCommandBar(
                            title: intl.market_edit_favorites,
                            description: intl.market_move_assets_or_delete,
                            buttonText: intl.market_done,
                            onTap: () {
                              setState(() {
                                isReorderingMod = false;
                              });
                            },
                          ),
                        ),
                      ),
                    if (listsStore.activeMarketTab != MarketTab.favorites) ...[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: SStandardField(
                            controller: listsStore.searchContriller,
                            focusNode: listsStore.searchFocusNode,
                            hintText: intl.showKycCountryPicker_search,
                            onChanged: (value) {},
                            height: 44,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: divider.SDivider(),
                        ),
                      ),
                    ],
                    if (listsStore.activeMarketTab == MarketTab.favorites && activeAssetsList.isEmpty)
                      const SliverPadding(
                        padding: EdgeInsets.only(
                          top: 16,
                          left: 24,
                          right: 24,
                          bottom: 32,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: AddAssetsBannerWidget(),
                        ),
                      ),
                    if (listsStore.activeMarketTab == MarketTab.favorites && isReorderingMod)
                      SliverReorderableList(
                        proxyDecorator: (child, index, animation) {
                          return _proxyDecorator(
                            child: child,
                            index: index,
                            animation: animation,
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          watchlistIdsN.changePosition(oldIndex, newIndex);

                          setState(() {});
                        },
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ReorderableDelayedDragStartListener(
                            key: list[index].key,
                            enabled: isReorderingMod,
                            index: index,
                            child: list[index],
                          );
                        },
                      )
                    else
                      SliverList.builder(
                        itemCount: activeAssetsList.length,
                        itemBuilder: (context, index) {
                          final currency = getIt.get<FormatService>().findCurrency(
                                findInHideTerminalList: true,
                                assetSymbol: activeAssetsList[index].symbol,
                              );
                          final isInWatchlist = watchlistIdsN.state.contains(currency.symbol);

                          final candles = chartStore.getAssetCandles(activeAssetsList[index].associateAssetPair);

                          return Slidable(
                            startActionPane: ActionPane(
                              extentRatio: 0.2,
                              motion: const ScrollMotion(),
                              children: [
                                Builder(
                                  builder: (context) {
                                    return CustomSlidableAction(
                                      onPressed: (context) {
                                        isInWatchlist
                                            ? watchlistIdsN.removeFromWatchlist(currency.symbol)
                                            : watchlistIdsN.addToWatchlist(currency.symbol);
                                      },
                                      backgroundColor: colors.blue,
                                      child: isInWatchlist
                                          ? Assets.svg.medium.favourite3.simpleSvg(
                                              color: colors.white,
                                            )
                                          : Assets.svg.medium.favourite.simpleSvg(
                                              color: colors.white,
                                            ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            child: SimpleTableAsset(
                              assetIcon: NetworkIconWidget(
                                currency.iconUrl,
                              ),
                              label: currency.description,
                              rightValue: (baseCurrency.symbol == currency.symbol ? Decimal.one : currency.currentPrice)
                                  .toFormatPrice(
                                prefix: baseCurrency.prefix,
                                accuracy: activeAssetsList[index].priceAccuracy,
                              ),
                              supplement: currency.symbol,
                              isRightValueMarket: true,
                              rightMarketValue: formatPercent(currency.dayPercentChange),
                              rightValueMarketPositive: currency.dayPercentChange >= 0,
                              onTableAssetTap: () {
                                sRouter.push(
                                  MarketDetailsRouter(
                                    marketItem: activeAssetsList[index],
                                  ),
                                );
                              },
                              chartWidget: SmallChart(
                                candles: candles,
                                width: 32,
                                height: 12,
                                lineWith: 1.8,
                                maxCandles: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    if (listsStore.activeMarketTab == MarketTab.favorites &&
                        activeAssetsList.isNotEmpty &&
                        !isReorderingMod)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 16,
                            children: [
                              SButtonContext(
                                type: SButtonContextType.iconedSmall,
                                text: intl.market_add_assets,
                                onTap: () {
                                  showAddAssetsBottomSheet(context);
                                },
                              ),
                              SButtonContext(
                                type: SButtonContextType.iconedSmall,
                                text: intl.market_edit_list,
                                onTap: () {
                                  setState(() {
                                    isReorderingMod = true;
                                  });
                                },
                                icon: Assets.svg.medium.edit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Widget> reorderingItems(List<MarketItemModel> marketItems, BuildContext context) {
    final watchlistIdsN = WatchlistStore.of(context);

    final baseCurrency = sSignalRModules.baseCurrency;

    final list = <Widget>[];

    for (final marketItem in marketItems) {
      final currency = getIt.get<FormatService>().findCurrency(
            findInHideTerminalList: true,
            assetSymbol: marketItem.symbol,
          );
      list.add(
        SimpleTableAsset(
          key: ValueKey(marketItem.symbol),
          assetIcon: NetworkIconWidget(
            marketItem.iconUrl,
          ),
          label: currency.description,
          rightValue: currency.currentPrice.toFormatPrice(
            prefix: baseCurrency.prefix,
            accuracy: marketItem.priceAccuracy,
          ),
          supplement: currency.symbol,
          customRightWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SafeGesture(
                    onTap: () {
                      watchlistIdsN.removeFromWatchlist(marketItem.symbol);
                    },
                    child: Assets.svg.medium.delete.simpleSvg(),
                  ),
                  const SizedBox(width: 16),
                  Assets.svg.small.reorder.simpleSvg(),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  Widget _proxyDecorator({
    required Widget child,
    required int index,
    required Animation<double> animation,
  }) {
    final colors = sKit.colors;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.white,
              boxShadow: [
                BoxShadow(
                  color: colors.grey1.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
