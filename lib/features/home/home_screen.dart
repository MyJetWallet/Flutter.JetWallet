import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/home/widgets/bottom_navigation_menu.dart';
import 'package:simple_kit/modules/bottom_sheets/components/simple_shade_animation_stack.dart';

List<PageRouteInfo<dynamic>> screens = [
  MarketRouter(),
  const PortfolioRouter(),
  const EarnRouter(),
  const AccountRouter(),
];

List<PageRouteInfo<dynamic>> screensWithNews = [
  MarketRouter(),
  const PortfolioRouter(),
  const NewsRouter(),
  const AccountRouter(),
];

class HomeScreen extends StatefulObserverWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final bool earnEnabled = sSignalRModules.earnProfile?.earnEnabled ?? false;

  late AnimationController animationController;

  void animationListener() {}

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animationController.addListener(animationListener);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: earnEnabled ? screens : screensWithNews,
      builder: (context, child, animation) {
        return SShadeAnimationStack(
          showShade: getIt.get<AppStore>().actionMenuActive,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      bottomNavigationBuilder: (_, tabsRouter) {
        getIt.get<AppStore>().setTabsRouter(tabsRouter);

        return BottomNavigationMenu(
          transitionAnimationController: animationController,
          currentIndex: getIt.get<AppStore>().homeTab,
          onChanged: (int val) {
            getIt<AppStore>().setHomeTab(val);
            tabsRouter.setActiveIndex(val);
          },
        );
      },
    );
  }
}
