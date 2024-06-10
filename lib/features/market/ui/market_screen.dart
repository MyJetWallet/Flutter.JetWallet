import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_nested_scroll_view.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/di/di.dart';
import '../../../core/services/prevent_duplication_events_servise.dart';

@RoutePage(name: 'MarketRouter')
class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('market-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'market-screen-key',
                event: sAnalytics.marketListScreenView,
              );
        }
      },
      child: const Scaffold(
        body: MarketNestedScrollView(
          marketShowType: MarketShowType.crypto,
          showBanners: true,
          showSearch: true,
          showFilter: true,
          sourceScreen: FilterMarketTabAction.all,
        ),
      ),
    );
  }
}
