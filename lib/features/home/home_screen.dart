import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'HomeRouter')
class HomeScreen extends StatefulObserverWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool earnEnabled = false;

  @override
  void initState() {
    super.initState();

    if (!getIt.isRegistered<KycService>()) {
      getIt.registerSingleton(KycService());
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<BottomBarStore>();

    return Observer(
      builder: (context) {
        final bottomBarItems = store.bottomBarItems;

        final screens = <PageRouteInfo<dynamic>>[
          if (bottomBarItems.contains(BottomItemType.home)) const MyWalletsRouter(),
          if (bottomBarItems.contains(BottomItemType.market)) const MarketRouter(),
          if (bottomBarItems.contains(BottomItemType.earn)) const EarnRouter(),
          if (bottomBarItems.contains(BottomItemType.invest)) const InvestPageRouter(),
          if (bottomBarItems.contains(BottomItemType.card)) const CardRouter(),
          if (bottomBarItems.contains(BottomItemType.cryptoCard)) const CryptoCardRootRoute(),
          if (bottomBarItems.contains(BottomItemType.rewards)) const RewardsFlowRouter(),
        ];

        return AutoTabsScaffold(
          routes: screens,
          transitionBuilder: (context, child, animation) {
            return Observer(
              builder: (context) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
          bottomNavigationBuilder: (_, tabsRouter) {
            store.setTabsRouter(tabsRouter);

            if (tabsRouter.activeIndex != store.cerrentIndex) {
              tabsRouter.setActiveIndex(store.cerrentIndex);
            }

            return SBottomBar(
              selectedIndex: store.cerrentIndex,
              items: [
                if (bottomBarItems.contains(BottomItemType.home))
                  SBottomItemModel(
                    type: BottomItemType.home,
                    text: intl.bottom_bar_home,
                    icon: Assets.svg.large.home,
                  ),
                if (bottomBarItems.contains(BottomItemType.market))
                  SBottomItemModel(
                    type: BottomItemType.market,
                    text: intl.bottom_bar_market,
                    icon: Assets.svg.large.graph,
                  ),
                if (bottomBarItems.contains(BottomItemType.earn))
                  SBottomItemModel(
                    type: BottomItemType.earn,
                    text: intl.earn_earn,
                    icon: Assets.svg.large.chart,
                  ),
                if (bottomBarItems.contains(BottomItemType.invest))
                  SBottomItemModel(
                    type: BottomItemType.invest,
                    text: intl.bottom_bar_invest,
                    icon: Assets.svg.large.crypto,
                  ),
                if (bottomBarItems.contains(BottomItemType.card))
                  SBottomItemModel(
                    type: BottomItemType.card,
                    text: intl.bottom_bar_card,
                    icon: Assets.svg.large.card,
                  ),
                if (bottomBarItems.contains(BottomItemType.cryptoCard))
                  SBottomItemModel(
                    type: BottomItemType.cryptoCard,
                    text: intl.bottom_bar_card,
                    icon: Assets.svg.large.card,
                  ),
                if (bottomBarItems.contains(BottomItemType.rewards))
                  SBottomItemModel(
                    type: BottomItemType.rewards,
                    text: intl.rewards_flow_tab_title,
                    icon: Assets.svg.large.rewards,
                    notification: sSignalRModules.rewardsData?.availableSpins ?? 0,
                  ),
              ],
              onChanged: (int val) {
                switch (bottomBarItems[val]) {
                  case BottomItemType.home:
                    sAnalytics.tapOnTheTabWalletsInTabBar();
                  case BottomItemType.rewards:
                    break;
                  case BottomItemType.earn:
                    sAnalytics.tapOnTheTabbarButtonEarn();
                  case BottomItemType.market:
                    sAnalytics.tapOnTheTabbarButtonMarket();
                  default:
                }

                getIt.get<EventBus>().fire(EndReordering());

                if (bottomBarItems[val] == store.homeTab) {
                  switch (bottomBarItems[val]) {
                    case BottomItemType.home:
                      getIt.get<EventBus>().fire(ResetScrollMyWallets());
                    case BottomItemType.market:
                      getIt.get<EventBus>().fire(ResetScrollMarket());
                    case BottomItemType.card:
                      getIt.get<EventBus>().fire(ResetScrollCard());
                    default:
                  }
                }

                store.setHomeTab(bottomBarItems[val]);
                if (val < screens.length) {
                  tabsRouter.setActiveIndex(val);
                } else {
                  tabsRouter.setActiveIndex(screens.length - 1);
                }
              },
            );
          },
        );
      },
    );
  }
}
