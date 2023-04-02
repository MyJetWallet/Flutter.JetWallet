import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_nested_scroll_view.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/watchlist_tab_bar_view.dart';
import 'package:jetwallet/widgets/bottom_tabs/bottom_tabs.dart';
import 'package:jetwallet/widgets/bottom_tabs/components/bottom_tab.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'MarketRouter')
class MarketScreen extends StatefulObserverWidget {
  const MarketScreen({
    Key? key,
    this.initIndex = 0,
  }) : super(key: key);

  final int initIndex;

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();

    _controller = getController();

    getIt<AppStore>().setMarketController(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TabController getController() {
    return TabController(
      length: 2,
      initialIndex: widget.initIndex,
      vsync: this,
    );
  }

  Widget marketWidget() {
    return const MarketNestedScrollView(
      marketShowType: MarketShowType.Crypto,
      showBanners: true,
      showSearch: true,
      showFilter: true,
      sourceScreen: FilterMarketTabAction.all,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    ReactionBuilder(
      builder: (context) {
        return reaction<bool>(
          (_) =>
              sSignalRModules.nftList.isNotEmpty &&
              sSignalRModules.clientDetail.isNftEnable,
          (result) {
            setState(() {
              _controller = getController();
              getIt<AppStore>().setMarketController(_controller);
            });
          },
          fireImmediately: true,
        );
      },
      */

    final showNFT = sSignalRModules.nftList.isNotEmpty &&
        sSignalRModules.clientDetail.isNftEnable;

    return Scaffold(
      body: !showNFT
          ? marketWidget()
          : Stack(
              children: [
                TabBarView(
                  controller: getIt<AppStore>().marketController,
                  children: [
                    marketWidget(),
                    const MarketNestedScrollView(
                      marketShowType: MarketShowType.NFT,
                      showFilter: true,
                      sourceScreen: FilterMarketTabAction.all,
                    ),
                  ],
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: BottomTabs(
                    tabController: getIt<AppStore>().marketController,
                    tabs: [
                      BottomTab(
                        text: showNFT
                            ? intl.market_crypto
                            : intl.market_allCrypto,
                      ),
                      BottomTab(
                        text: intl.market_nft,
                        //isActive: DefaultTabController.of(context)!.index == 2,
                        isTextBlue: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
