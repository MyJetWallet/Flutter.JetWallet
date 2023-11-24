import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/account_app_bar/account_appbar.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';

class CollapsedAccountAppbar extends HookWidget {
  const CollapsedAccountAppbar({
    Key? key,
    required this.scrollController,
    this.mainBlockCenter = false,
    required this.mainTitle,
    this.mainSubtitle,
    required this.mainHeaderTitle,
    this.mainHeaderSubtitle,
    required this.mainHeaderCollapsedTitle,
    this.mainHeaderCollapsedSubtitle,
    this.showTicker = true,
    this.ticker,
    this.assetIcon,
  }) : super(key: key);

  final ScrollController scrollController;
  final bool mainBlockCenter;

  final String mainTitle;
  final String? mainSubtitle;

  final bool showTicker;
  final String? ticker;
  final Widget? assetIcon;

  final String mainHeaderTitle;
  final String? mainHeaderSubtitle;

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
      firstChild: AccountAppBar(
        mainTitle: mainTitle,
        mainSubtitle: mainSubtitle,
        mainBlockCenter: mainBlockCenter,
        headerTitle: mainHeaderTitle,
        headerSubtitle: mainHeaderSubtitle,
        showTicker: showTicker,
        ticker: ticker,
        assetIcon: assetIcon,
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
