import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';
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
      end: 80.0,
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
        height: 96.0,
        child: Column(
          children: [
            if (scaleAnimation.value == 0) ...[
              const SDivider(),
              const SpaceH13(),
            ] else
              const SpaceH14(),
            Row(
              children: [
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => onChanged(0),
                    child: _MenuItemFrame(
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
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => onChanged(1),
                    child: _MenuItemFrame(
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
                const Spacer(),
                SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: STransparentInkWell(
                    onTap: onActionTap,
                    child: actionActive
                        ? const SActionActiveIcon()
                        : const SActionDefaultIcon(),
                  ),
                ),
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => onChanged(2),
                    child: _MenuItemFrame(
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
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => onChanged(3),
                    child: _MenuItemFrame(
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
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemFrame extends StatelessWidget {
  const _MenuItemFrame({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Stack(
        children: children,
      ),
    );
  }
}
