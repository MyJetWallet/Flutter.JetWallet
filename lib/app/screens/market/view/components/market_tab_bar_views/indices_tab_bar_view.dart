import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/market_indices_pod.dart';
import 'components/market_nested_scroll_view.dart';
import 'helper/reset_market_scroll_position.dart';

class IndicesTabBarView extends StatefulHookWidget {
  const IndicesTabBarView({Key? key}) : super(key: key);

  @override
  State<IndicesTabBarView> createState() => _IndicesTabBarState();
}

class _IndicesTabBarState extends State<IndicesTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final indices = context.read(marketIndicesPod);

    _scrollController.addListener(() {
      resetMarketScrollPosition(
        context,
        indices.length,
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
    final indices = useProvider(marketIndicesPod);

    return MarketNestedScrollView(
      items: indices,
      controller: _scrollController,
    );
  }
}
