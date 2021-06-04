import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/shared/components/loader.dart';

import '../providers/navigation_stpod.dart';
import '../providers/notification_fpod.dart';
import 'components/bottom_navigation_menu/bottom_navigation_menu.dart';
import 'components/screens.dart';

class Navigation extends HookWidget {
  static const routeName = '/navigation';

  @override
  Widget build(BuildContext context) {
    final navigation = useProvider(navigationStpod);
    final notificationInit = useProvider(notificationInitFpod);

    return notificationInit.when(
      data: (_) {
        return Scaffold(
          body: SafeArea(
            child: screens[navigation.state],
          ),
          bottomNavigationBar: const BottomNavigationMenu(),
        );
      },
      loading: () => Loader(),
      error: (e, _) => Text('$e'),
    );
  }
}
