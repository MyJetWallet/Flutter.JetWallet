import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/providers/background/push_notification_pods.dart';
import '../../../shared/features/key_value/provider/key_value_spod.dart';
import '../../../shared/providers/client_detail_pod/client_detail_pod.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../provider/navigation_stpod.dart';
import 'components/bottom_navigation_menu.dart';
import 'components/screens.dart';

class Navigation extends StatefulHookWidget {
  static const routeName = '/navigation';

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = useProvider(navigationStpod);
    useProvider(pushNotificationRegisterTokenPod.select((_) {}));
    useProvider(pushNotificationOnTokenRefreshPod.select((_) {}));
    useProvider(currenciesPod.select((_) {}));
    useProvider(clientDetailPod.select((_) {}));
    useProvider(keyValueSpod.select((_) {}));
    useListenable(animationController);

    return Scaffold(
      body: SShadeAnimationStack(
        controller: animationController,
        child: screens[navigation.state],
      ),
      bottomNavigationBar: BottomNavigationMenu(
        transitionAnimationController: animationController,
      ),
    );
  }
}
