import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/helpers/market_references.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/helper/market_gainers.dart';
import 'package:jetwallet/features/market/helper/market_indices.dart';
import 'package:jetwallet/features/market/helper/market_losers.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_nested_scroll_view.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/watchlist_tab_bar_view.dart';
import 'package:jetwallet/widgets/bottom_tabs/bottom_tabs.dart';
import 'package:jetwallet/widgets/bottom_tabs/components/bottom_tab.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketScreen extends StatefulObserverWidget {
  const MarketScreen({
    Key? key,
    this.initIndex = 1,
  }) : super(key: key);

  final int initIndex;

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
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

  late TabController _controller;
  //int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    final showCrypto = sSignalRModules.nftList.isNotEmpty;

    _controller = TabController(
      length: showCrypto ? 3 : 2,
      initialIndex: widget.initIndex,
      vsync: this,
    );

    getIt<AppStore>().setMarketController(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //useProvider(keyValueNotipod);
    //useProvider(watchlistIdsNotipod);

    //List<MarketItemModel> allItems = sSignalRModules.marketItems;
    //final indices = getMarketIndices();
    //final gainers = getMarketGainers();
    //final losers = getMarketLosers();

    //Timer.periodic(
    //  const Duration(milliseconds: 100),
    //  (Timer t) => print(sSignalRModules.marketItems),
    //);

    // TODO: refactor

    //final timeTrackerN = useProvider(timeTrackingNotipod.notifier);

    /*
    final marketTabsLength = _marketTabsLength(
      //gainers.isEmpty,
      //losers.isEmpty,
      //indices.isEmpty,
    );
    */

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await timeTrackerN.updateMarketOpened();
      //await timeTrackerN.isFinishedOnMarketCheck();
    });

    final cryptoPrices = sSignalRModules.getMarketPrices;
    final nftMarket = sSignalRModules.nftList;

    final showCrypto = sSignalRModules.nftList.isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: getIt<AppStore>().marketController,
            children: [
              const WatchlistTabBarView(),
              MarketNestedScrollView(
                items: cryptoPrices,
                nft: const [],
                showBanners: true,
                sourceScreen: FilterMarketTabAction.all,
              ),
              if (showCrypto) ...[
                MarketNestedScrollView(
                  items: const [],
                  nft: nftMarket,
                  showFilter: true,
                  sourceScreen: FilterMarketTabAction.all,
                ),
              ],
              /*
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
                        */
            ],
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: BottomTabs(
              tabController: getIt<AppStore>().marketController,
              tabs: [
                const BottomTab(
                  icon: SStarIcon(),
                ),
                BottomTab(text: intl.market_crypto),
                if (showCrypto) ...[
                  BottomTab(
                    text: intl.market_nft,
                    //isActive: DefaultTabController.of(context)!.index == 2,
                    isTextBlue: true,
                  ),
                ],
                /*
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
                          */
              ],
            ),
          ),
        ],
      ),
    );

    /*
    return Scaffold(
      body: TabBarView(
        //initialIndex: widget.initIndex,
        //length: showCrypto ? 3 : 2,
        controller: _controller,
        children: [],
        child: Builder(builder: (context) {
          
        }),
      ),
    );
    */
  }
}
