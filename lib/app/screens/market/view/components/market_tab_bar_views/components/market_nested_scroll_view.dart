import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/helpers/formatting/base/market_format.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../model/market_item_model.dart';
import '../../fade_on_scroll.dart';
import '../../market_banners/market_banners.dart';
import '../helper/reset_market_scroll_position.dart';


class MarketNestedScrollView extends StatefulHookWidget {
  const MarketNestedScrollView({
    Key? key,
    this.showBanners = false,
    required this.items,
    required this.controller,
  }) : super(key: key);

  final List<MarketItemModel> items;
  final ScrollController controller;
  final bool showBanners;

  @override
  State<MarketNestedScrollView> createState() => _MarketNestedScrollViewState();
}

class _MarketNestedScrollViewState extends State<MarketNestedScrollView> {

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      resetMarketScrollPosition(
        context,
        widget.items.length,
        widget.controller,
      );
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);

    return NestedScrollView(
      controller: widget.controller,
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
              scrollController: widget.controller,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: const SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Market is up',
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      body: Container(
        color: colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (widget.showBanners)
            const MarketBanners(),
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
                  accuracy: baseCurrency.accuracy,
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
