import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/ui/widgets/market_not_loaded.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../model/market_item_model.dart';
import '../../fade_on_scroll.dart';
import '../../market_banners/market_banners.dart';
import '../helper/reset_market_scroll_position.dart';
import 'market_header_stats.dart';

class MarketNestedScrollView extends StatefulObserverWidget {
  const MarketNestedScrollView({
    Key? key,
    this.showBanners = false,
    required this.items,
    required this.sourceScreen,
  }) : super(key: key);

  final List<MarketItemModel> items;
  final bool showBanners;
  final FilterMarketTabAction sourceScreen;

  @override
  State<MarketNestedScrollView> createState() => _MarketNestedScrollViewState();
}

class _MarketNestedScrollViewState extends State<MarketNestedScrollView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    sAnalytics.marketFilter(widget.sourceScreen);

    controller.addListener(() {
      resetMarketScrollPosition(
        context,
        widget.items.length,
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

    return NestedScrollView(
      controller: controller,
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
              fadeOutWidget: widget.items.isNotEmpty
                  ? const MarketHeaderStats()
                  : const MarketHeaderSkeletonStats(),
              permanentWidget: SMarketHeaderClosed(
                title: intl.marketNestedScrollView_market,
              ),
            ),
          ),
        ];
      },
      body: widget.items.isNotEmpty
          ? ColoredBox(
              color: colors.white,
              child: Column(
                children: [
                  if (widget.showBanners) const MarketBanners(),
                  Flexible(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        return SMarketItem(
                          icon: SNetworkSvg24(
                            url: widget.items[index].iconUrl,
                          ),
                          name: widget.items[index].name,
                          price: marketFormat(
                            prefix: baseCurrency.prefix,
                            decimal: widget.items[index].lastPrice,
                            symbol: baseCurrency.symbol,
                            accuracy: widget.items[index].priceAccuracy,
                          ),
                          ticker: widget.items[index].symbol,
                          last: widget.items[index] == widget.items.last,
                          percent: widget.items[index].dayPercentChange,
                          onTap: () {
                            sRouter.push(
                              MarketDetailsRouter(
                                marketItem: widget.items[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SpaceH40(),
                ],
              ),
            )
          : const MarketNotLoaded(),
    );
  }
}
