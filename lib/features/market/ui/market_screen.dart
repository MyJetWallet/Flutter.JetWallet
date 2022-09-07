import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/helpers/market_references.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/helper/market_gainers.dart';
import 'package:jetwallet/features/market/helper/market_indices.dart';
import 'package:jetwallet/features/market/helper/market_losers.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_nested_scroll_view.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/watchlist_tab_bar_view.dart';
import 'package:jetwallet/widgets/bottom_tabs/bottom_tabs.dart';
import 'package:jetwallet/widgets/bottom_tabs/components/bottom_tab.dart';
import 'package:simple_analytics/simple_analytics.dart';

class MarketScreen extends StatefulObserverWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _marketTabsLength(
    bool gainersEmpty,
    bool losersEmpty,
    bool indicesEmpty,
  ) {
    var marketTabsLength = 5;

    if (gainersEmpty) {
      marketTabsLength--;
    }
    if (losersEmpty) {
      marketTabsLength--;
    }
    if (indicesEmpty) {
      marketTabsLength--;
    }

    return marketTabsLength;
  }

  @override
  Widget build(BuildContext context) {
    //useProvider(keyValueNotipod);
    //useProvider(watchlistIdsNotipod);

    List<MarketItemModel> allItems = sSignalRModules.marketItems;
    final indices = getMarketIndices();
    final gainers = getMarketGainers();
    final losers = getMarketLosers();

    //Timer.periodic(
    //  const Duration(milliseconds: 100),
    //  (Timer t) => print(sSignalRModules.marketItems),
    //);

    // TODO: refactor

    //final timeTrackerN = useProvider(timeTrackingNotipod.notifier);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      losers.isEmpty,
      indices.isEmpty,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await timeTrackerN.updateMarketOpened();
      //await timeTrackerN.isFinishedOnMarketCheck();
    });

    return Builder(
      builder: (_) {
        final value = sSignalRModules.randomStream.value;
        final mRItems = sSignalRModules.marketReferences.value;
        final currencies = sSignalRModules.getCurrencies;

        final allAssets = marketReferencesList(
          mRItems!,
          currencies,
        );

        final ass = sSignalRModules.getMarketPrices;

        return Scaffold(
          body: DefaultTabController(
            length: marketTabsLength,
            child: Stack(
              children: [
                TabBarView(
                  children: [
                    MarketNestedScrollView(
                      items: ass,
                      showBanners: true,
                      sourceScreen: FilterMarketTabAction.all,
                    ),
                    const WatchlistTabBarView(),
                    if (indices.isNotEmpty)
                      MarketNestedScrollView(
                        items: indices,
                        sourceScreen: FilterMarketTabAction.cryptoSets,
                      ),
                    if (gainers.isNotEmpty)
                      MarketNestedScrollView(
                        items: gainers,
                        sourceScreen: FilterMarketTabAction.gainers,
                      ),
                    if (losers.isNotEmpty)
                      MarketNestedScrollView(
                        items: losers,
                        sourceScreen: FilterMarketTabAction.losers,
                      ),
                  ],
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: BottomTabs(
                    tabs: [
                      BottomTab(text: intl.market_all),
                      BottomTab(text: intl.market_bottomTabLabel2),
                      if (indices.isNotEmpty)
                        BottomTab(
                          text: intl.market_bottomTabLabel3,
                        ),
                      if (gainers.isNotEmpty)
                        BottomTab(
                          text: intl.market_bottomTabLabel4,
                        ),
                      if (losers.isNotEmpty)
                        BottomTab(
                          text: intl.market_bottomTabLabel5,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
