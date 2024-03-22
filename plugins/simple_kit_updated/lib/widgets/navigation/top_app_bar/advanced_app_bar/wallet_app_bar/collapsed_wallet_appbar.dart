import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/wallet_app_bar/wallet_appbar.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';

class CollapsedWalletAppbar extends HookWidget {
  const CollapsedWalletAppbar({
    super.key,
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
    this.hasRightIcon = false,
    this.carouselItemsCount,
    this.carouselPageIndex,
    this.needCarousel = true,
  });

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
  final bool hasRightIcon;

  final int? carouselItemsCount;
  final int? carouselPageIndex;
  final bool needCarousel;

  @override
  Widget build(BuildContext context) {
    final isTopPosition = useState(true);

    void onScrollAction() {
      if (scrollController.position.pixels <= 10) {
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
      firstChild: WalletAppBar(
        mainTitle: mainTitle,
        mainSubtitle: mainSubtitle,
        mainBlockCenter: mainBlockCenter,
        headerTitle: mainHeaderTitle,
        headerSubtitle: mainHeaderSubtitle,
        showTicker: showTicker,
        ticker: ticker,
        assetIcon: assetIcon,
        needCarousel: needCarousel,
        carouselItemsCount: carouselItemsCount,
        carouselPageIndex: carouselPageIndex,
      ),
      secondChild: Material(
        color: Colors.white,
        child: GlobalBasicAppBar(
          title: mainHeaderCollapsedTitle,
          subtitle: mainHeaderCollapsedSubtitle,
          hasRightIcon: hasRightIcon,
        ),
      ),
      crossFadeState: isTopPosition.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }
}
