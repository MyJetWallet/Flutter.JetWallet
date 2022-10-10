import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/helper/nft_filer_modal.dart';
import 'package:jetwallet/features/market/store/market_filter_store.dart';
import 'package:jetwallet/features/market/ui/widgets/market_not_loaded.dart';
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

import '../../../../model/market_item_model.dart';
import '../../fade_on_scroll.dart';
import '../../market_banners/market_banners.dart';
import '../helper/reset_market_scroll_position.dart';
import 'market_header_stats.dart';

class MarketNestedScrollView extends StatelessWidget {
  const MarketNestedScrollView({
    super.key,
    this.showBanners = false,
    this.showFilter = false,
    required this.items,
    required this.nft,
    required this.sourceScreen,
  });

  final List<MarketItemModel> items;
  final List<NftModel> nft;
  final bool showBanners;
  final bool showFilter;
  final FilterMarketTabAction sourceScreen;

  @override
  Widget build(BuildContext context) {
    return Provider<MarketFilterStore>(
      create: (context) => MarketFilterStore()..init(items, nft),
      builder: (context, child) => _MarketNestedScrollViewBody(
        showBanners: showBanners,
        showFilter: showFilter,
        items: items,
        nft: nft,
        sourceScreen: sourceScreen,
      ),
    );
  }
}

class _MarketNestedScrollViewBody extends StatefulObserverWidget {
  const _MarketNestedScrollViewBody({
    super.key,
    this.showBanners = false,
    this.showFilter = false,
    required this.items,
    required this.nft,
    required this.sourceScreen,
  });

  final List<MarketItemModel> items;
  final List<NftModel> nft;
  final bool showBanners;
  final bool showFilter;
  final FilterMarketTabAction sourceScreen;

  @override
  State<_MarketNestedScrollViewBody> createState() =>
      __MarketNestedScrollViewBodyState();
}

class __MarketNestedScrollViewBodyState
    extends State<_MarketNestedScrollViewBody> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    sAnalytics.marketFilter(widget.sourceScreen);

    controller.addListener(() {
      resetMarketScrollPosition(
        context,
        MarketFilterStore.of(context).cryptoList.isNotEmpty
            ? widget.items.length
            : widget.nft.length,
        controller,
      );
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final colors = sKit.colors;
    final store = MarketFilterStore.of(context);

    final showPreloader = widget.items.isEmpty || widget.nft.isEmpty;

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
                      activeFilters: store.nftFilterSelected.length,
                      onFilterButtonTap: widget.showFilter
                          ? () {
                              showNFTFilterModalSheet(
                                context,
                                store as MarketFilterStore,
                              );
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
              child: store.cryptoList.isNotEmpty
                  ? showCryptoList(baseCurrency)
                  : showNFTList(),
            )
          : const MarketNotLoaded(),
    );
  }

  Widget showCryptoList(BaseCurrencyModel baseCurrency) {
    final store = MarketFilterStore.of(context);

    return Column(
      children: [
        if (widget.showBanners) const MarketBanners(),
        Flexible(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: store.cryptoListFiltred.length,
            itemBuilder: (context, index) {
              return SMarketItem(
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
              );
            },
          ),
        ),
        const SpaceH40(),
      ],
    );
  }

  Widget showNFTList() {
    final store = MarketFilterStore.of(context);

    return Column(
      children: [
        if (widget.showBanners) const MarketBanners(),
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
                  sRouter.push(
                    NftCollectionDetailsRouter(
                      nft: store.nftListFiltred[index],
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
