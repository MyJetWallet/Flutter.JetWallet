import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../provider/market_info_pod.dart';
import '../fade_on_scroll.dart';
import 'components/market_reordable_list.dart';

class WatchlistTabBarView extends StatefulHookWidget {
  const WatchlistTabBarView({Key? key}) : super(key: key);

  @override
  State<WatchlistTabBarView> createState() => _WatchlistTabBarViewState();
}

class _WatchlistTabBarViewState extends State<WatchlistTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final marketInfo = useProvider(marketInfoPod);

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
              fadeOutWidget: SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: marketInfo.toString(),
                  isPositive: marketInfo > Decimal.zero,
                  subtitle:
                      'Market is ${(marketInfo > Decimal.zero) ?
                      'up' :
                      'down'
                    }',
                  showInfo: marketInfo != Decimal.zero,
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      body: const MarketReorderableList(),
    );
  }
}
