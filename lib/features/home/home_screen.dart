import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/home/widgets/bottom_navigation_menu.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/bottom_sheets/components/simple_shade_animation_stack.dart';

import '../../utils/helpers/check_kyc_status.dart';
import '../kyc/kyc_service.dart';

@RoutePage(name: 'HomeRouter')
class HomeScreen extends StatefulObserverWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool earnEnabled = sSignalRModules.earnProfile?.earnEnabled ?? false;

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    final hideAccount = sSignalRModules.currenciesList
        .where(
          (element) => element.supportsIbanDeposit,
        )
        .toList()
        .isEmpty;

    return Observer(
      builder: (context) {
        final screens = <PageRouteInfo<dynamic>>[
          const PortfolioRouter(),
          MarketRouter(),
        ];

        if (!hideAccount) {
          screens.add(IBanRouter());
        }
        if (sUserInfo.cardAvailable) {
          screens.add(const CardRouter());
        }

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

            return BottomNavigationMenu(
              currentIndex: getIt.get<AppStore>().homeTab,
              hideAccount: hideAccount,
              isCardRequested: sUserInfo.cardRequested || kycBlocked,
              showCard: sUserInfo.cardAvailable,
              onChanged: (int val) {
                if (val == 2) {
                  getIt<IbanStore>().initState();
                  getIt<IbanStore>().getAddressBook();

                  sAnalytics.accountTabScreenView();
                }

                if (val == 0 && getIt<AppStore>().homeTab == 0) {
                  getIt.get<EventBus>().fire(ResetScrollMyAssets());
                } else if (val == 1 && getIt<AppStore>().homeTab == 1) {
                  getIt.get<EventBus>().fire(ResetScrollMarket());
                } else if (val == 2 && getIt<AppStore>().homeTab == 2) {
                  getIt.get<EventBus>().fire(ResetScrollAccount());
                } else if (val == 3 && getIt<AppStore>().homeTab == 3) {
                  getIt.get<EventBus>().fire(ResetScrollCard());
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
