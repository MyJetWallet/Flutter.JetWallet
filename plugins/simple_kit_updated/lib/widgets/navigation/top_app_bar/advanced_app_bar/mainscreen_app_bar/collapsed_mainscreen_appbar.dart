import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/mainscreen_app_bar/mainscreen_appbar.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';

class CollapsedMainscreenAppbar extends HookWidget {
  const CollapsedMainscreenAppbar({
    Key? key,
    required this.scrollController,
    required this.mainHeaderCollapsedTitle,
    required this.child,
    this.mainHeaderCollapsedSubtitle,
    required this.mainHeaderTitle,
    this.mainHeaderValue,
  }) : super(key: key);

  final ScrollController scrollController;

  final Widget child;

  final String mainHeaderTitle;
  final String? mainHeaderValue;

  final String mainHeaderCollapsedTitle;
  final String? mainHeaderCollapsedSubtitle;

  @override
  Widget build(BuildContext context) {
    final isTopPosition = useState(true);

    void onScrollAction() {
      if (scrollController.position.pixels <= 50) {
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
        child: child,
      ),
      secondChild: Material(
        color: Colors.white,
        child: GlobalBasicAppBar(
          title: mainHeaderCollapsedTitle,
          subtitle: mainHeaderCollapsedSubtitle,
        ),
      ),
      crossFadeState: isTopPosition.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }
}
