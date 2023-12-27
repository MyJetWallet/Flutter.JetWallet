import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';
import 'components/simple_market_header_title.dart';

class SMarketHeader extends StatelessWidget {
  const SMarketHeader({
    Key? key,
    this.onSearchButtonTap,
    this.onFilterButtonTap,
    this.activeFilters = 0,
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.isPositive,
    required this.showInfo,
    required this.isLoader,
  }) : super(key: key);

  final int activeFilters;
  final void Function()? onSearchButtonTap;
  final void Function()? onFilterButtonTap;
  final String title;
  final String subtitle;
  final String percent;
  final bool isPositive;
  final bool showInfo;
  final bool isLoader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.0,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 53.0,
          ),
          SimpleMarketHeaderTitle(
            key: key,
            title: title,
            onSearchButtonTap: onSearchButtonTap,
            onFilterButtonTap: onFilterButtonTap,
            activeFilters: activeFilters,
          ),
          if (showInfo) ...[
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  subtitle,
                  style: sSubtitle2Style.copyWith(
                    color: SColorsLight().grey1,
                  ),
                ),
                Text(
                  ' ${isPositive ? '+' : ''} $percent%',
                  style: sSubtitle2Style.copyWith(
                    color:
                        isPositive ? SColorsLight().green : SColorsLight().red,
                  ),
                ),
                Baseline(
                  baseline: 27.4,
                  baselineType: TextBaseline.alphabetic,
                  child: isPositive
                      ? const SBigArrowPositiveIcon()
                      : const SBigArrowNegativeIcon(),
                ),
              ],
            ),
          ],
          if (isLoader) ...[
            const SizedBox(
              height: 18,
            ),
            const SSkeletonTextLoader(
              height: 16,
              width: 159,
            ),
          ],
        ],
      ),
    );
  }
}
