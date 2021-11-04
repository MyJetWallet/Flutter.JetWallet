import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';
import 'components/notification_box.dart';

class SBottomNavigationBar extends StatelessWidget {
  const SBottomNavigationBar({
    Key? key,
    this.marketNotifications = 0,
    this.portfolioNotifications = 0,
    this.newsNotifications = 0,
    this.profileNotifications = 0,
    required this.selectedIndex,
    required this.actionActive,
    required this.onActionTap,
    required this.onChanged,
  }) : super(key: key);

  final int marketNotifications;
  final int portfolioNotifications;
  final int newsNotifications;
  final int profileNotifications;
  final int selectedIndex;
  final bool actionActive;
  final void Function() onActionTap;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      height: 96.h,
      child: Column(
        children: [
          const SpaceH14(),
          Row(
            children: [
              SizedBox(
                width: 23.5.w,
              ),
              if (!actionActive) ...[
                STransparentInkWell(
                  onTap: () => onChanged(0),
                  child: Stack(
                    children: [
                      if (selectedIndex == 0)
                        const SMarketActiveIcon()
                      else
                        const SMarketDefaultIcon(),
                      NotificationBox(
                        notifications: marketNotifications,
                      )
                    ],
                  ),
                ),
                const SpaceW12(),
                STransparentInkWell(
                  onTap: () => onChanged(1),
                  child: Stack(
                    children: [
                      if (selectedIndex == 1)
                        const SPortfolioActiveIcon()
                      else
                        const SPortfolioDefaultIcon(),
                      NotificationBox(
                        notifications: portfolioNotifications,
                      )
                    ],
                  ),
                ),
              ] else
                const Spacer(),
              const SpaceW12(),
              STransparentInkWell(
                onTap: onActionTap,
                child: actionActive
                    ? const SActionActiveIcon()
                    : const SActionDefaultIcon(),
              ),
              const SpaceW12(),
              if (!actionActive) ...[
                STransparentInkWell(
                  onTap: () => onChanged(2),
                  child: Stack(
                    children: [
                      if (selectedIndex == 2)
                        const SNewsActiveIcon()
                      else
                        const SNewsDefaultIcon(),
                      NotificationBox(
                        notifications: newsNotifications,
                      )
                    ],
                  ),
                ),
                const SpaceW12(),
                STransparentInkWell(
                  onTap: () => onChanged(3),
                  child: Stack(
                    children: [
                      if (selectedIndex == 3)
                        const SProfileActiveIcon()
                      else
                        const SProfileDefaultIcon(),
                      NotificationBox(
                        notifications: profileNotifications,
                      )
                    ],
                  ),
                ),
              ] else
                const Spacer(),
              SizedBox(
                width: 23.5.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
