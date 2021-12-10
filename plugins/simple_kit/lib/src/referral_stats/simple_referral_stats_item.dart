import 'package:flutter/material.dart';
import '../../simple_kit.dart';

class SReferralStatsItem extends StatelessWidget {
  const SReferralStatsItem({
    Key? key,
    this.baselineHeight = 40.0,
    this.valueColor,
    required this.value,
    required this.text,
  }) : super(key: key);

  final String text;
  final double baselineHeight;
  final String value;
  final Color? valueColor;

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
            style: (valueColor != null)
                ? sSubtitle3Style.copyWith(color: valueColor)
                : sSubtitle3Style,
          ),
        ),
      ],
    );
  }
}
