import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
    this.isLoading = false,
    this.onOnChatTap,
    required this.userAvatar,
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

  final VoidCallback? onOnChatTap;

  final bool isLoading;

  final Widget userAvatar;

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
        isLoading: isLoading,
        onOnChatTap: onOnChatTap,
        userAvatar: userAvatar,
        onUserAvatarTap: () {
          onProfileTap?.call();
        },
        child: child,
      ),
      secondChild: Material(
        color: Colors.white,
        child: GlobalBasicAppBar(
          title: mainHeaderCollapsedTitle,
          subtitle: mainHeaderCollapsedSubtitle,
          hasLeftIcon: true,
          leftIcon: userAvatar,
          onLeftIconTap: () {
            onProfileTap?.call();
          },
          hasRightIcon: true,
          rightIcon: SafeGesture(
            onTap: onOnChatTap,
            child: Assets.svg.medium.chat.simpleSvg(),
          ),
        ),
      ),
      crossFadeState: isTopPosition.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }
}
