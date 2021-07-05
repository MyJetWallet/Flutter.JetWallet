import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/providers/service_providers.dart';
import 'bottom_navigation_item.dart';

class BottomNavigationMenu extends HookWidget {
  const BottomNavigationMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return SizedBox(
      height: 45.h,
      child: Material(
        color: Colors.white,
        child: Row(
          children: [
            BottomNavigationItem(
              index: 0,
              icon: Icons.account_balance_wallet,
              name: intl.wallet,
            ),
            BottomNavigationItem(
              index: 1,
              icon: Icons.portrait,
              name: intl.profile,
            ),
            BottomNavigationItem(
              index: 2,
              icon: Icons.bar_chart,
              name: intl.chart,
            ),
            const BottomNavigationItem(
              index: 3,
              icon: Icons.bug_report,
              name: 'Logs',
            ),
          ],
        ),
      ),
    );
  }
}
