import 'package:flutter/material.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SBottomNavigationBar extends StatefulWidget {
  const SBottomNavigationBar({
    Key? key,
    this.marketNotifications = 0,
    required this.cardNotifications,
    this.portfolioNotifications = 0,
    this.earnNotifications = 0,
    this.profileNotifications = 0,
    required this.animationController,
    required this.selectedIndex,
    required this.actionActive,
    required this.onActionTap,
    required this.onChanged,
    required this.earnEnabled,
  }) : super(key: key);

  final int marketNotifications;
  final int portfolioNotifications;
  final int earnNotifications;
  final int profileNotifications;
  final AnimationController animationController;
  final int selectedIndex;
  final bool actionActive;
  final bool earnEnabled;
  final bool cardNotifications;
  final void Function() onActionTap;
  final void Function(int) onChanged;

  @override
  State<SBottomNavigationBar> createState() => _SBottomNavigationBarState();
}

class _SBottomNavigationBarState extends State<SBottomNavigationBar>
    with TickerProviderStateMixin {
  late Animation _animation;
  late Offset translateOffset;

  @override
  void initState() {
    _animation = Tween(
      begin: 0.0,
      end: 80.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.linear,
      ),
    );

    translateOffset = Offset(0, _animation.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.actionActive) {
        setState(() {
          translateOffset = const Offset(0, 80);
        });
      } else {
        setState(() {
          translateOffset = const Offset(0, 0);
        });
      }
    });

    /*
    final scaleAnimation = Tween(
      begin: 0.0,
      end: 80.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.linear,
      ),
    );

    final translateOffset = Offset(0, scaleAnimation.value);
  */

    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        height: 96.0,
        child: Column(
          children: [
            if (_animation.value == 0) ...[
              const SDivider(),
              const SpaceH13(),
            ] else
              const SpaceH14(),
            Row(
              children: [
                const Spacer(),
                AnimatedBuilder(
                  animation: widget.animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: translateOffset,
                      child: STransparentInkWell(
                        onTap: () => widget.onChanged(0),
                        child: _MenuItemFrame(
                          children: [
                            if (widget.selectedIndex == 0)
                              const SMarketActiveIcon()
                            else
                              const SMarketDefaultIcon(),
                            NotificationBox(
                              notifications: widget.marketNotifications,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(1),
                    child: _MenuItemFrame(
                      children: [
                        if (widget.selectedIndex == 1)
                          const SPortfolioActiveIcon()
                        else
                          const SPortfolioDefaultIcon(),
                        NotificationBox(
                          notifications: widget.portfolioNotifications,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: STransparentInkWell(
                    onTap: () {
                      widget.onActionTap();
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: widget.actionActive
                          ? const SActionActiveIcon()
                          : const SActionDefaultIcon(),
                    ),
                  ),
                ),
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(2),
                    child: _MenuItemFrame(
                      children: [
                        if (widget.selectedIndex == 2) ...[
                          if (widget.earnEnabled) ...[
                            const SEarnActiveIcon(),
                          ] else ...[
                            const SNewsActiveIcon(),
                          ],
                        ] else ...[
                          if (widget.earnEnabled) ...[
                            const SEarnDefaultIcon(),
                          ] else ...[
                            const SNewsDefaultIcon(),
                          ],
                        ],
                        NotificationBox(
                          notifications: widget.earnNotifications,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Transform.translate(
                  offset: translateOffset,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(3),
                    child: _MenuItemFrame(
                      children: [
                        if (widget.selectedIndex == 3)
                          const SProfileActiveIcon()
                        else
                          const SProfileDefaultIcon(),
                        NotificationBox(
                          notifications: widget.profileNotifications,
                          cardsFailed: widget.cardNotifications,
                        ),
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
