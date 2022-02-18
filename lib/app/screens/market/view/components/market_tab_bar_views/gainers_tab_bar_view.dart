import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/market_gainers_pod.dart';
import 'components/market_nested_scroll_view.dart';

class GainersTabBarView extends StatefulHookWidget {
  const GainersTabBarView({Key? key}) : super(key: key);

  @override
  State<GainersTabBarView> createState() => _GainersTabBarState();
}

class _GainersTabBarState extends State<GainersTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final gainers = useProvider(marketGainersPod);

    return MarketNestedScrollView(
      items: gainers,
      controller: _scrollController,
    );
  }
}
