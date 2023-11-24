import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/navigation/carousel/carousel_widget.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/advanced_app_bar_base.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class AccountAppBar extends StatelessWidget {
  const AccountAppBar({
    Key? key,
    required this.mainTitle,
    this.mainSubtitle,
    this.ticker,
    this.assetIcon,
    this.showTicker = true,
    required this.mainBlockCenter,
    this.headerHasTitle = true,
    this.headerTitle,
    this.headerHasSubtitle = true,
    this.headerSubtitle,
    this.hasLeftIcon = true,
    this.leftIcon,
    this.hasRightIcon = false,
    this.rightIcon,
    this.onRightIconTap,
    this.needCarousel = false,
    this.carouselItemsCount,
    this.carouselPageIndex,
  }) : super(key: key);

  final bool mainBlockCenter;

  final String mainTitle;

  final String? mainSubtitle;

  final bool showTicker;
  final String? ticker;
  final Widget? assetIcon;

  final bool headerHasTitle;
  final String? headerTitle;
  final bool headerHasSubtitle;
  final String? headerSubtitle;
  final bool hasLeftIcon;
  final Widget? leftIcon;
  final bool hasRightIcon;
  final Widget? rightIcon;

  final VoidCallback? onRightIconTap;

  final bool needCarousel;
  final int? carouselItemsCount;
  final int? carouselPageIndex;

  @override
  Widget build(BuildContext context) {
    return AdvancedAppBarBase(
      isShortVersion: needCarousel,
      flow: CollapsedAppBarType.account,
      child: Column(
        children: [
          GlobalBasicAppBar(
            hasTitle: headerHasTitle,
            title: headerTitle,
            hasSubtitle: headerHasSubtitle,
            subtitle: headerSubtitle,
            hasLeftIcon: hasLeftIcon,
            leftIcon: leftIcon,
            hasRightIcon: hasRightIcon,
            rightIcon: rightIcon,
            subtitleTextColor: SColorsLight().blackAlfa52,
            onRightIconTap: onRightIconTap,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: mainBlockCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  if (showTicker)
                    SizedBox(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: mainBlockCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: assetIcon ?? Assets.svg.medium.crypto.simpleSvg(),
                          ),
                          const Gap(8),
                          Text(
                            ticker ?? '',
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    mainTitle,
                    style: STStyles.header2.copyWith(
                      color: SColorsLight().black,
                    ),
                  ),
                  Opacity(
                    opacity: mainSubtitle != null ? 1 : 0,
                    child: Text(
                      mainSubtitle ?? '',
                      style: STStyles.body2Medium.copyWith(
                        color: SColorsLight().gray10,
                      ),
                    ),
                  ),
                  if (needCarousel) ...[
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: CarouselWidget(
                        itemsCount: carouselItemsCount ?? 1,
                        pageIndex: carouselPageIndex ?? 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
