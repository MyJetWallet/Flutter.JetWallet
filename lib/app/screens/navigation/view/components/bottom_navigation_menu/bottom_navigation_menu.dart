import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        color: Colors.grey[100],
        child: Row(
          children: [
            BottomNavigationItem(
              index: 0,
              icon: FontAwesomeIcons.chartBar,
              name: intl.market,
            ),
            BottomNavigationItem(
              index: 1,
              icon: FontAwesomeIcons.wallet,
              name: intl.portfolio,
            ),
            BottomNavigationItem(
              index: 2,
              icon: FontAwesomeIcons.plusCircle,
              name: intl.action,
            ),
            BottomNavigationItem(
              index: 3,
              icon: FontAwesomeIcons.graduationCap,
              name: intl.education,
            ),
            BottomNavigationItem(
              index: 4,
              icon: FontAwesomeIcons.user,
              name: intl.account,
            ),
          ],
        ),
      ),
    );
  }
}
