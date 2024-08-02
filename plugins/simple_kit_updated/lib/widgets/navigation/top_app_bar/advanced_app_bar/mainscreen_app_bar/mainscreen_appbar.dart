import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/advanced_app_bar_base.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_large_alt_appbar.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class MainScreenAppbar extends StatelessWidget {
  const MainScreenAppbar({
    super.key,
    this.showIcon = true,
    required this.child,
    required this.headerTitle,
    this.headerValue,
    required this.isLabelIconShow,
    this.onLabelIconTap,
    this.onProfileTap,
    this.isLoading = false,
    this.onOnChatTap,
    required this.userAvatar,
    this.onUserAvatarTap,
  });

  final bool showIcon;
  final Widget child;

  final String headerTitle;
  final String? headerValue;

  final bool isLabelIconShow;
  final VoidCallback? onLabelIconTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onOnChatTap;

  final bool isLoading;

  final Widget userAvatar;
  final VoidCallback? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    return AdvancedAppBarBase(
      isShortVersion: false,
      flow: CollapsedAppBarType.mainScreen,
      child: Column(
        children: [
          SimpleLargeAltAppbar(
            title: headerTitle,
            value: headerValue,
            showLabelIcon: true,
            labelIcon: isLabelIconShow ? Assets.svg.medium.hide.simpleSvg() : Assets.svg.medium.show.simpleSvg(),
            onLabelIconTap: onLabelIconTap,
            hasRightIcon: true,
            rightIcon: SafeGesture(
              onTap: onOnChatTap,
              child: Assets.svg.medium.chat.simpleSvg(),
            ),
            hasLeftIcon: true,
            leftIcon: SafeGesture(
              onTap: onUserAvatarTap,
              child: userAvatar,
            ),
            isLoading: isLoading,
          ),
          child,
        ],
      ),
    );
  }
}
