import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/bottom_sheets/components/simple_shade_animation_stack.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

import '../../utils/helpers/check_kyc_status.dart';
import '../kyc/kyc_service.dart';

@RoutePage(name: 'HomeRouter')
class HomeScreen extends StatefulObserverWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool earnEnabled = false;

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.tradeStatus,
      kycState.withdrawalStatus,
    );

    final bottomBarItems = <BottomItemType>[
      BottomItemType.wallets,
      BottomItemType.market,
      if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
          .any((element) => element.id == AssetPaymentProductsEnum.earnProgram)) ...[
        BottomItemType.earn,
      ],
      if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
          .where((element) => element.id == AssetPaymentProductsEnum.investProgram)
          .isNotEmpty) ...[
        BottomItemType.invest,
      ],
      if (sUserInfo.cardAvailable && displayCardPreorderScreen) ...[
        BottomItemType.card,
      ],
      if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
          .where((element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram)
          .isNotEmpty) ...[
        BottomItemType.rewards,
      ],
    ];

    return Observer(
      builder: (context) {
        final screens = <PageRouteInfo<dynamic>>[
          if (bottomBarItems.contains(BottomItemType.wallets)) const MyWalletsRouter(),
          if (bottomBarItems.contains(BottomItemType.market)) const MarketRouter(),
          if (bottomBarItems.contains(BottomItemType.earn)) const EarnRouter(),
          if (bottomBarItems.contains(BottomItemType.invest)) const InvestPageRouter(),
          if (bottomBarItems.contains(BottomItemType.card)) const CardRouter(),
          if (bottomBarItems.contains(BottomItemType.rewards)) const RewardsFlowRouter(),
        ];

        return AutoTabsScaffold(
          routes: screens,
          transitionBuilder: (context, child, animation) {
            return Observer(
              builder: (context) {
                return SShadeAnimationStack(
                  showShade: getIt.get<AppStore>().actionMenuActive,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
            );
          },
          bottomNavigationBuilder: (_, tabsRouter) {
            getIt.get<AppStore>().setTabsRouter(tabsRouter);

            return SBottomBar(
              selectedIndex: getIt.get<AppStore>().homeTab,
              items: [
                if (bottomBarItems.contains(BottomItemType.wallets))
                  SBottomItemModel(
                    type: BottomItemType.wallets,
                    text: intl.bottom_bar_wallets,
                    icon: Assets.svg.large.wallets,
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
                    icon: Assets.svg.large.graph,
                  ),
                if (bottomBarItems.contains(BottomItemType.card))
                  SBottomItemModel(
                    type: BottomItemType.card,
                    text: intl.bottom_bar_card,
                    icon: Assets.svg.large.card,
                    notification: (sUserInfo.cardRequested || kycBlocked) ? 0 : 1,
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
                  case BottomItemType.wallets:
                    sAnalytics.tapOnTheTabWalletsInTabBar();
                  case BottomItemType.rewards:
                    sAnalytics.rewardsTapOnTheTabBar();
                  case BottomItemType.earn:
                    sAnalytics.tapOnTheTabbarButtonEarn();
                  default:
                }

                getIt.get<EventBus>().fire(EndReordering());

                if (val == getIt<AppStore>().homeTab) {
                  switch (bottomBarItems[val]) {
                    case BottomItemType.wallets:
                      getIt.get<EventBus>().fire(ResetScrollMyWallets());
                    case BottomItemType.market:
                      getIt.get<EventBus>().fire(ResetScrollMarket());
                    case BottomItemType.card:
                      getIt.get<EventBus>().fire(ResetScrollCard());
                    default:
                  }
                }

                getIt<AppStore>().setHomeTab(val);
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
