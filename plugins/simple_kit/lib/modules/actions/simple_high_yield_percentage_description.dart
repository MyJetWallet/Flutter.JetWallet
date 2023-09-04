import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SHighYieldPercentageDescription extends StatelessWidget {
  const SHighYieldPercentageDescription({
    Key? key,
    required this.widgetSize,
    required this.onTap,
    required this.tiers,
    required this.hot,
    required this.error,
    this.apy = '',
  }) : super(key: key);

  final SWidgetSize widgetSize;
  final void Function()? onTap;
  final String apy;
  final List<SimpleTierModel> tiers;
  final bool hot;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final colorTheme = hot
        ? [
            SColorsLight().orange,
            SColorsLight().brown,
            SColorsLight().darkBrown,
          ]
        : [
            SColorsLight().seaGreen,
            SColorsLight().leafGreen,
            SColorsLight().aquaGreen,
          ];
    final textColor = tiers.length > 1
        ? tiers[1].active
            ? colorTheme[1]
            : colorTheme[0]
        : colorTheme[0];

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
              if (widgetSize == SWidgetSize.small) const SpaceH16(),
              // + 1 px border
              if (widgetSize == SWidgetSize.medium) const SpaceH27(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW19(), // + 1 px border
                  SimplePercentageIndicator(
                    tiers: tiers,
                    isHot: hot,
                  ),
                  const SpaceW20(),
                  Stack(
                    children: [
                      if (error)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: SColorsLight().grey5,
                            shape: BoxShape.circle,
                          ),
                          child: const LoaderSpinner(
                            size: 32,
                          ),
                        ),
                      Baseline(
                        baseline: 27,
                        baselineType: TextBaseline.alphabetic,
                        child: Opacity(
                          opacity: error ? 0 : 1,
                          child: Text(
                            apy,
                            style: sTextH2Style.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceW19(), // + 1 px border
                ],
              ),
              // + 1 px border
              if (widgetSize == SWidgetSize.small) const SpaceH10(),
            ],
          ),
        ),
      ),
    );
  }
}
