import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/background/push_notification_pods.dart';
import '../provider/navigation_stpod.dart';
import 'components/bottom_navigation_menu/bottom_navigation_menu.dart';
import 'components/screens.dart';

class Navigation extends HookWidget {
  static const routeName = '/navigation';

  @override
  Widget build(BuildContext context) {
    final navigation = useProvider(navigationStpod);
    useProvider(pushNotificationRegisterTokenPod.select((_) {}));
    useProvider(pushNotificationOnTokenRefreshPod.select((_) {}));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: screens[navigation.state],
      ),
      bottomNavigationBar: const BottomNavigationMenu(),
    );
  }
}
