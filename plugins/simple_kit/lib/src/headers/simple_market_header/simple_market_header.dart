import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';
import 'components/simple_market_header_title.dart';

class SMarketHeader extends StatelessWidget {
  const SMarketHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onSearchButtonTap,
    required this.percent,
    required this.isPositive,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Function() onSearchButtonTap;
  final double percent;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 64.0,
          ),
          SimpleMarketHeaderTitle(
            title: title,
            onSearchButtonTap: onSearchButtonTap,
          ),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Baseline(
                baseline: 31.4,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  subtitle,
                  style: sSubtitle2Style.copyWith(
                    color: SColorsLight().grey1,
                  ),
                ),
              ),
              Baseline(
                baseline: 31.4,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  ' ${isPositive ? '+' : '-'} $percent%',
                  style: sSubtitle2Style.copyWith(
                    color:
                        isPositive ? SColorsLight().green : SColorsLight().red,
                  ),
                ),
              ),
              Baseline(
                baseline: 37.4,
                baselineType: TextBaseline.alphabetic,
                child: isPositive
                    ? const SBigArrowPositiveIcon()
                    : const SBigArrowNegativeIcon(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
