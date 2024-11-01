import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SReferralStatsItem extends StatelessWidget {
  const SReferralStatsItem({
    super.key,
    this.valueColor,
    this.baselineHeight = 40.0,
    required this.value,
    required this.text,
  });

  final Color? valueColor;
  final double baselineHeight;
  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Baseline(
          baseline: baselineHeight,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            text,
            style: sBodyText2Style.copyWith(
              color: SColorsLight().grey1,
            ),
          ),
        ),
        Baseline(
          baseline: baselineHeight,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            value,
            style: sSubtitle3Style.copyWith(
              color: valueColor ?? SColorsLight().black,
            ),
          ),
        ),
      ],
    );
  }
}
