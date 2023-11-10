import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_nested_scroll_view.dart';
import 'package:simple_analytics/simple_analytics.dart';

@RoutePage(name: 'MarketRouter')
class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MarketNestedScrollView(
        marketShowType: MarketShowType.crypto,
        showBanners: true,
        showSearch: true,
        showFilter: true,
        sourceScreen: FilterMarketTabAction.all,
      ),
    );
  }
}
