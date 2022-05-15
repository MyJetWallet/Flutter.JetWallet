import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SHighYieldPercentageDescription extends StatelessWidget {
  const SHighYieldPercentageDescription({
    Key? key,
    required this.widgetSize,
    required this.onTap,
    required this.tiers,
    this.apy = '',
  }) : super(key: key);

  final SWidgetSize widgetSize;
  final Function() onTap;
  final String apy;
  final List<SimpleTierModel> tiers;

  @override
  Widget build(BuildContext context) {
    final textColor = tiers.length > 1
        ? tiers[1].active
            ? SColorsLight().leafGreen
            : SColorsLight().seaGreen
        : SColorsLight().seaGreen;

    return SPaddingH24(
      child: InkWell(
        highlightColor: SColorsLight().grey4,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Ink(
          height: widgetSize == SWidgetSize.small ? 64.0 : 88.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              // + 1 px border
              if (widgetSize == SWidgetSize.small) const SpaceH19(),
              // + 1 px border
              if (widgetSize == SWidgetSize.medium) const SpaceH27(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW19(), // + 1 px border
                  SimplePercentageIndicator(
                    tiers: tiers,
                  ),
                  const SpaceW20(),
                  Baseline(
                    baseline: 27,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      apy,
                      style: sTextH2Style.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                  const SpaceW19(), // + 1 px border
                ],
              ),
              // + 1 px border
              if (widgetSize == SWidgetSize.small) const SpaceH17(),
            ],
          ),
        ),
      ),
    );
  }
}
