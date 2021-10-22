import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
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
      height: 160.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 64.h,
          ),
          SimpleMarketHeaderTitle(
            title: title,
            onSearchButtonTap: onSearchButtonTap,
          ),
          SizedBox(
            height: 40.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SSubtitleText2(
                  text: subtitle,
                  color: SColorsLight().grey1,
                ),
                SSubtitleText2(
                  text: ' ${isPositive ? '+' : '-'} $percent%',
                  color: isPositive ? SColorsLight().green : SColorsLight().red,
                ),
                if (isPositive)
                  const SBigArrowPositiveIcon()
                else
                  const SBigArrowNegativeIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
