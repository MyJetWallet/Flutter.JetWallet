import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/market_losers_pod.dart';
import 'components/market_nested_scroll_view.dart';
import 'helper/reset_market_scroll_position.dart';

class LosersTabBarView extends StatefulHookWidget {
  const LosersTabBarView({Key? key}) : super(key: key);

  @override
  State<LosersTabBarView> createState() => _LosersTabBarViewState();
}

class _LosersTabBarViewState extends State<LosersTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final losers = context.read(marketLosersPod);

    _scrollController.addListener(() {
      resetMarketScrollPosition(
        context,
        losers.length,
        _scrollController,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final losers = useProvider(marketLosersPod);

    return MarketNestedScrollView(
      items: losers,
      controller: _scrollController,
    );
  }
}
