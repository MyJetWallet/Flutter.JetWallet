import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/helpers/formatting/base/market_format.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../model/market_item_model.dart';
import '../../fade_on_scroll.dart';
import '../../market_banners/market_banners.dart';
import '../helper/reset_market_scroll_position.dart';
import 'market_header_stats.dart';

class MarketNestedScrollView extends StatefulHookWidget {
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
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

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
              fadeOutWidget: const MarketHeaderStats(),
              permanentWidget: SMarketHeaderClosed(
                title: intl.marketNestedScrollView_market,
              ),
            ),
          ),
        ];
      },
      body: ColoredBox(
        color: colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (widget.showBanners) const MarketBanners(),
            for (final item in widget.items) ...[
              SMarketItem(
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
                last: item == widget.items.last,
                percent: item.dayPercentChange,
                onTap: () {
                  navigatorPush(
                    context,
                    MarketDetails(
                      marketItem: item,
                    ),
                  );
                },
              ),
            ],
            const SpaceH40(),
          ],
        ),
      ),
    );
  }
}
