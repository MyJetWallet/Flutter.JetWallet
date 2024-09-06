import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/widgets/market_sector_item_widget.dart';
import 'package:jetwallet/features/market/widgets/top_movers_market_section.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/di/di.dart';
import '../../../core/services/prevent_duplication_events_servise.dart';

@RoutePage(name: 'MarketRouter')
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late final ScrollController _controller;

  bool isScroolStarted = false;

  @override
  void initState() {
    _controller = ScrollController();

    _controller.addListener(
      () {
        if (_controller.offset > 0 && !isScroolStarted) {
          setState(() {
            isScroolStarted = true;
          });
        } else if (_controller.offset <= 0 && isScroolStarted) {
          setState(() {
            isScroolStarted = false;
          });
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      child: SPageFrame(
        loaderText: '',
        header: AnimatedCrossFade(
          firstChild: GlobalBasicAppBar(
            title: intl.marketHeaderStats_market,
            hasLeftIcon: false,
            hasRightIcon: false,
          ),
          secondChild: SimpleLargeAltAppbar(
            title: intl.marketHeaderStats_market,
            showLabelIcon: false,
            hasRightIcon: false,
            hasTopPart: false,
          ),
          crossFadeState: isScroolStarted ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),

        child: Observer(
          builder: (context) {
            final sectors = sSignalRModules.marketSectors.sectors;
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: [
                const SliverToBoxAdapter(
                  child: STableHeader(
                    title: 'Sectors',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid.builder(
                    itemCount: sectors.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 64,
                      mainAxisExtent: 112,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 4.0,
                    ),
                    itemBuilder: (context, index) {
                      return MarketSectorItemWidget(
                        sector: sectors[index],
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: TopMoversMarketSection(),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 4,
                      children: [
                        STagButton(
                          lable: 'Favorites',
                        ),
                        STagButton(
                          lable: 'All',
                          state: TagButtonState.selected,
                        ),
                        STagButton(
                          lable: 'Gainers',
                        ),
                        STagButton(
                          lable: 'Loosers',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        //  MarketNestedScrollView(
        //   marketShowType: MarketShowType.crypto,
        //   showBanners: true,
        //   showSearch: true,
        //   showFilter: true,
        //   sourceScreen: FilterMarketTabAction.all,
        // ),
      ),
    );
  }
}
