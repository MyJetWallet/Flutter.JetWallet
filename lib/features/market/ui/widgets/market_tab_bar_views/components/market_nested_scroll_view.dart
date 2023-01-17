import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/helper/nft_filer_modal.dart';
import 'package:jetwallet/features/market/store/market_filter_store.dart';
import 'package:jetwallet/features/market/ui/widgets/market_not_loaded.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/nft_market_item.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/helper/nft_market.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/nft_count_items_in_collection.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_collections.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../helper/crypto_filer_modal.dart';
import '../../../../helper/crypto_search_modal.dart';
import '../../../../model/market_item_model.dart';
import '../../fade_on_scroll.dart';
import '../../market_banners/market_banners.dart';
import '../helper/reset_market_scroll_position.dart';
import 'market_header_stats.dart';

enum MarketShowType { Crypto, NFT }

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
  State<_MarketNestedScrollViewBody> createState() =>
      __MarketNestedScrollViewBodyState();
}

class __MarketNestedScrollViewBodyState
    extends State<_MarketNestedScrollViewBody> {
  final ScrollController controller = ScrollController();
  ScrollController marketScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    sAnalytics.marketFilter(widget.sourceScreen);

    controller.addListener(() {
      resetMarketScrollPosition(
        context,
        MarketFilterStore.of(context).cryptoList.isNotEmpty
            ? MarketFilterStore.of(context).cryptoList.length
            : MarketFilterStore.of(context).nftList.length,
        controller,
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

    final showPreloader =
        store.cryptoList.isNotEmpty || store.nftList.isNotEmpty;

    return NestedScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
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
                      activeFilters:
                          widget.marketShowType == MarketShowType.Crypto
                              ? store.activeFilter == 'all'
                                  ? 0
                                  : 1
                              : store.nftFilterSelected.length,
                      onFilterButtonTap: widget.showFilter
                          ? () {
                              if (widget.marketShowType == MarketShowType.NFT) {
                                sAnalytics.nftMarketTapFilter();
                                sAnalytics.nftMarketFilterShowed();
                                showNFTFilterModalSheet(
                                  context,
                                  store as MarketFilterStore,
                                );
                              } else {
                                showCryptoFilterModalSheet(
                                  context,
                                  store as MarketFilterStore,
                                );
                              }
                            }
                          : null,
                      onSearchButtonTap:
                          widget.marketShowType == MarketShowType.Crypto
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
              child: widget.marketShowType == MarketShowType.Crypto
                  ? showCryptoList(baseCurrency)
                  : showNFTList(),
            )
          : const MarketNotLoaded(),
    );
  }

  Widget showCryptoList(BaseCurrencyModel baseCurrency) {
    final store = MarketFilterStore.of(context);
    final showNFT = sSignalRModules.nftList.isNotEmpty &&
        sSignalRModules.clientDetail.isNftEnable;

    /*return Column(
      children: [
        Flexible(
          child: AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            initialItemCount: store.cryptoListFiltred.length,
            itemBuilder: (context, index, animation) {
              var isInWatchlist = false;

              if (store.cryptoListFiltred[index] != null) {
                isInWatchlist = store.watchListLocal.contains(
                  store.cryptoListFiltred[index].associateAsset,
                );
              }

              return SlideTransition(
                position: animation.drive(
                    Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                        .chain(CurveTween(curve: Curves.ease))),
                child: SMarketItem(
                  key: Key(
                    store.cryptoListFiltred[index].associateAsset,
                  ),
                  showFavoriteIcon: true,
                  isStarActive: isInWatchlist,
                  onStarButtonTap: () {
                    print(isInWatchlist);

                    if (isInWatchlist) {
                      store.removeFromWatchlist(
                        store.cryptoListFiltred[index].associateAsset,
                      );
                    } else {
                      sAnalytics.addToWatchlist(
                        store.cryptoListFiltred[index].name,
                      );
                      store.addToWatchlist(
                        store.cryptoListFiltred[index].associateAsset,
                      );
                    }
                  },
                  icon: SNetworkSvg24(
                    url: store.cryptoListFiltred[index].iconUrl,
                  ),
                  name: store.cryptoListFiltred[index].name,
                  price: marketFormat(
                    prefix: baseCurrency.prefix,
                    decimal: store.cryptoListFiltred[index].lastPrice,
                    symbol: baseCurrency.symbol,
                    accuracy: store.cryptoListFiltred[index].priceAccuracy,
                  ),
                  ticker: store.cryptoListFiltred[index].symbol,
                  last: store.cryptoListFiltred[index] ==
                      store.cryptoListFiltred.last,
                  percent: store.cryptoListFiltred[index].dayPercentChange,
                  onTap: () {
                    sRouter.push(
                      MarketDetailsRouter(
                        marketItem: store.cryptoListFiltred[index],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (showNFT) ...[
          const SpaceH40(),
        ],
      ],
    );*/

    return ListView(
      padding: EdgeInsets.zero,
      physics: store.isReordable
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      controller: marketScrollController,
      children: [
        if (store.watchListFiltred.isNotEmpty) ...[
          MarketSeparator(text: intl.favorite),
          ImplicitlyAnimatedReorderableList<MarketItemModel>(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            items: store.watchListFiltred,
            onReorderFinished: (item, from, to, newItems) {
              store.syncWatchListLocal(newItems.map((e) => e.symbol).toList());
            },
            areItemsTheSame: (a, b) => a == b,
            itemBuilder: (context, itemAnimation, item, index) {
              /*final isInWatchlist = store.watchListLocal.contains(
                store.cryptoListFiltred[index].associateAsset,
              );*/
              final isInWatchlist = true;

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
                              store.removeFromWatchlist(
                                item.associateAsset,
                              );
                            } else {
                              sAnalytics.addToWatchlist(
                                item.name,
                              );
                              store.addToWatchlist(
                                item.associateAsset,
                              );
                            }
                          },
                          icon: SNetworkSvg24(
                            url: item.iconUrl,
                          ),
                          name: item.name,
                          price: marketFormat(
                            prefix: baseCurrency.prefix,
                            decimal: item.lastPrice,
                            symbol: baseCurrency.symbol,
                            accuracy: item.priceAccuracy,
                          ),
                          ticker: item.symbol,
                          last: store.watchListFiltred.isNotEmpty
                              ? item == store.watchListFiltred.last
                              : true,
                          percent: item.dayPercentChange,
                          onTap: () {
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
        ],
        MarketSeparator(text: intl.assets),
        ImplicitlyAnimatedList<MarketItemModel>(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          items: store.cryptoFiltred,
          areItemsTheSame: (a, b) => a == b,
          itemBuilder: (context, animation, item, _) {
            bool isInWatchlist = false;

            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: SMarketItem(
                key: Key(
                  item.associateAsset,
                ),
                showFavoriteIcon: true,
                isStarActive: isInWatchlist,
                onStarButtonTap: () {
                  if (isInWatchlist) {
                    store.removeFromWatchlist(
                      item.associateAsset,
                    );
                  } else {
                    sAnalytics.addToWatchlist(
                      item.name,
                    );
                    store.addToWatchlist(
                      item.associateAsset,
                    );
                  }
                },
                icon: SNetworkSvg24(
                  url: item.iconUrl,
                ),
                name: item.name,
                price: marketFormat(
                  prefix: baseCurrency.prefix,
                  decimal: item.lastPrice,
                  symbol: baseCurrency.symbol,
                  accuracy: item.priceAccuracy,
                ),
                ticker: item.symbol,
                last: item == store.cryptoListFiltred.last,
                percent: item.dayPercentChange,
                onTap: () {
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
        /*GroupedListView<MarketItemModel, String>(
          elements: store.cryptoListFiltred,
          groupBy: (item) {
            final isInWatchlist = store.watchListLocal.contains(
              item.associateAsset,
            );

            return isInWatchlist ? intl.favorite : intl.assets;
          },
          padding: EdgeInsets.zero,
          sort: false,
          groupSeparatorBuilder: (String text) {
            return MarketSeparator(text: text);
          },
          itemBuilder: (context, item) {
            final isInWatchlist = store.watchListLocal.contains(
              item.associateAsset,
            );

            return SMarketItem(
              key: Key(
                item.associateAsset,
              ),
              showFavoriteIcon: true,
              isStarActive: isInWatchlist,
              onStarButtonTap: () {
                if (isInWatchlist) {
                  store.removeFromWatchlist(
                    item.associateAsset,
                  );
                } else {
                  sAnalytics.addToWatchlist(
                    item.name,
                  );
                  store.addToWatchlist(
                    item.associateAsset,
                  );
                }
              },
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.name,
              price: marketFormat(
                prefix: baseCurrency.prefix,
                decimal: item.lastPrice,
                symbol: baseCurrency.symbol,
                accuracy: item.priceAccuracy,
              ),
              ticker: item.symbol,
              last: item == store.cryptoListFiltred.last ||
                      store.watchListLocal != null
                  ? store.watchListLocal.isNotEmpty
                      ? item.symbol == (store.watchListLocal.last)
                      : false
                  : false,
              percent: item.dayPercentChange,
              onTap: () {
                sRouter.push(
                  MarketDetailsRouter(
                    marketItem: item,
                  ),
                );
              },
            );
          },
        ),
        */
      ],
    );
  }

  Widget showNFTList() {
    final store = MarketFilterStore.of(context);

    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: store.nftListFiltred.length,
            itemBuilder: (context, index) {
              return NftMarketItem(
                image: '$shortUrl${store.nftListFiltred[index].sImage}',
                name: store.nftListFiltred[index].name ?? '',
                descr: nftMarketDescr(
                  store.nftListFiltred[index].nftList.length,
                  store.nftListFiltred[index].tags ?? [],
                ),
                onTap: () {
                  sAnalytics.nftCollectionView(
                    nftCollectionID: store.nftListFiltred[index].id!,
                    source: 'Market',
                  );
                  sAnalytics.nftMarketTapCollection(
                    collectionTitle: store.nftListFiltred[index].name ?? '',
                    nftNumberPictures:
                        '${store.nftListFiltred[index].nftList.length}',
                    nftCategories:
                        store.nftListFiltred[index].category.toString(),
                  );
                  sRouter.push(
                    NftCollectionDetailsRouter(
                      collectionID: store.nftListFiltred[index].id!,
                    ),
                  );
                },
                last: store.nftListFiltred[index] == store.nftListFiltred.last,
              );
            },
          ),
        ),
        const SpaceH40(),
      ],
    );
  }
}
