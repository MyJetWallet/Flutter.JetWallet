import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/market_items_pod.dart';
import 'components/market_nested_scroll_view.dart';

class AllTabBarView extends StatefulHookWidget {
  const AllTabBarView({Key? key}) : super(key: key);

  @override
  State<AllTabBarView> createState() => _AllTabBarViewState();
}

class _AllTabBarViewState extends State<AllTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketItemsPod);

    return MarketNestedScrollView(
      items: items,
      controller: _scrollController,
      showBanners: true,
    );
  }
}
