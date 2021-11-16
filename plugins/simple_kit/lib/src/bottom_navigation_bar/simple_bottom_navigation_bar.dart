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
    required this.animationController,
    required this.selectedIndex,
    required this.actionActive,
    required this.onActionTap,
    required this.onChanged,
  }) : super(key: key);

  final int marketNotifications;
  final int portfolioNotifications;
  final int newsNotifications;
  final int profileNotifications;
  final AnimationController animationController;
  final int selectedIndex;
  final bool actionActive;
  final void Function() onActionTap;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween(
      begin: 0.0,
      end: 80.h,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    final translateOffset = Offset(0, scaleAnimation.value);

    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        width: 375.w,
        height: 96.h,
        child: Column(
          children: [
            const SDivider(),
            const SpaceH13(),
            Row(
              children: [
                SizedBox(
                  width: 23.5.w,
                ),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
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
                ),
                const SpaceW12(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
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
                ),
                const SpaceW12(),
                STransparentInkWell(
                  onTap: onActionTap,
                  child: actionActive
                      ? const SActionActiveIcon()
                      : const SActionDefaultIcon(),
                ),
                const SpaceW12(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
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
                ),
                const SpaceW12(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
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
                ),
                SizedBox(
                  width: 23.5.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
