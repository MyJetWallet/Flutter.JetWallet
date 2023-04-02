import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/home/widgets/bottom_navigation_menu.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:simple_kit/modules/bottom_sheets/components/simple_shade_animation_stack.dart';

List<PageRouteInfo<dynamic>> screens = [
  const PortfolioRouter(),
  MarketRouter(),
  const IBanRouter(),
];

List<PageRouteInfo<dynamic>> screensWithoutIban = [
  const PortfolioRouter(),
  MarketRouter(),
];

@RoutePage(name: 'HomeRouter')
class HomeScreen extends StatefulObserverWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool earnEnabled = sSignalRModules.earnProfile?.earnEnabled ?? false;
  final bool hideAccount = sSignalRModules.currenciesList
      .where(
        (element) => element.supportsIbanDeposit,
      )
      .toList()
      .isEmpty;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return AutoTabsScaffold(
          routes: hideAccount ? screensWithoutIban : screens,
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
              onChanged: (int val) {
                if (val == 2) {
                  getIt<IbanStore>().initState();
                }
                getIt<AppStore>().setHomeTab(val);
                tabsRouter.setActiveIndex(val);
              },
            );
          },
        );
      },
    );
  }
}
