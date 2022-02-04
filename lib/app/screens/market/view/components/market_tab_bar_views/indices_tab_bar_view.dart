import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../shared/helpers/format_currency_amount.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../provider/market_indices_pod.dart';
import '../fade_on_scroll.dart';

class IndicesTabBarView extends StatefulHookWidget {
  const IndicesTabBarView({Key? key}) : super(key: key);

  @override
  State<IndicesTabBarView> createState() =>
      _IndicesTabBarState();
}

class _IndicesTabBarState extends State<IndicesTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final indices = useProvider(marketIndicesPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: _scrollController,
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
      body: ListView(
        key: const PageStorageKey('indices'),
        padding: EdgeInsets.zero,
        children: [
          for (final item in indices) ...[
            SMarketItem(
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.name,
              price: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: item.lastPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: item.id,
              last: item == indices.last,
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
    );
  }
}
