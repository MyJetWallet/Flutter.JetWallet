import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/mainscreen_app_bar/mainscreen_appbar.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/shared/icons/user_noty_icon.dart';

class CollapsedMainscreenAppbar extends HookWidget {
  const CollapsedMainscreenAppbar({
    super.key,
    required this.scrollController,
    required this.mainHeaderCollapsedTitle,
    required this.child,
    this.mainHeaderCollapsedSubtitle,
    required this.mainHeaderTitle,
    this.mainHeaderValue,
    required this.isLabelIconShow,
    this.onLabelIconTap,
    this.onProfileTap,
    this.profileNotificationsCount = 0,
    this.isLoading = false,
  });

  final ScrollController scrollController;

  final Widget child;

  final String mainHeaderTitle;
  final String? mainHeaderValue;

  final String mainHeaderCollapsedTitle;
  final String? mainHeaderCollapsedSubtitle;

  final bool isLabelIconShow;
  final VoidCallback? onLabelIconTap;

  final VoidCallback? onProfileTap;
  final int profileNotificationsCount;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isTopPosition = useState(true);

    void onScrollAction() {
      if (scrollController.position.pixels <= 0) {
        if (!isTopPosition.value) {
          isTopPosition.value = true;
        }
      } else {
        if (isTopPosition.value) {
          isTopPosition.value = false;
        }
      }
    }

    useEffect(
      () {
        scrollController.addListener(onScrollAction);
        return () => scrollController.removeListener(onScrollAction);
      },
      [scrollController],
    );

    return AnimatedCrossFade(
      firstChild: MainScreenAppbar(
        headerTitle: mainHeaderTitle,
        headerValue: mainHeaderValue,
        onLabelIconTap: onLabelIconTap,
        isLabelIconShow: isLabelIconShow,
        onProfileTap: onProfileTap,
        profileNotificationsCount: profileNotificationsCount,
        isLoading: isLoading,
        child: child,
      ),
      secondChild: Material(
        color: Colors.white,
        child: GlobalBasicAppBar(
          title: mainHeaderCollapsedTitle,
          subtitle: mainHeaderCollapsedSubtitle,
          hasLeftIcon: false,
          hasRightIcon: true,
          rightIcon: UserNotyIcon(
            onTap: onProfileTap ?? () {},
            notificationsCount: profileNotificationsCount,
          ),
        ),
      ),
      crossFadeState: isTopPosition.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }
}
