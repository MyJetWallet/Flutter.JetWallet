import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SimplePercentageIndicator extends StatelessWidget {
  const SimplePercentageIndicator({
    super.key,
    this.expanded = false,
    this.isHot = false,
    required this.tiers,
  });

  final List<SimpleTierModel> tiers;
  final bool expanded;
  final bool isHot;

  @override
  Widget build(BuildContext context) {
    final singleTier = tiers.length == 1;
    final doubleTier = tiers.length == 2;
    final colorTheme = isHot
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

    if (tiers.isEmpty) {
      return Expanded(
        child: Container(
          height: 32,
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 2,
            bottom: 4,
            left: 8,
          ),
          decoration: BoxDecoration(
            color: SColorsLight().grey5,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              'Please wait ...',
              style: sSubtitle3Style.copyWith(
                color: SColorsLight().grey3,
              ),
            ),
          ),
        ),
      );
    } else {
      if (singleTier) {
        return Expanded(
          child: Container(
            height: 32,
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 4,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: colorTheme[0],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              '${tiers[0].apy}%',
              style: sSubtitle3Style.copyWith(
                color: SColorsLight().white,
              ),
            ),
          ),
        );
      } else if (doubleTier) {
        return Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorTheme[1],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: 4,
                      left: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorTheme[0],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      '${tiers[0].apy}%',
                      style: sSubtitle3Style.copyWith(
                        color: SColorsLight().white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: 4,
                      left: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorTheme[1],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      '${tiers[1].apy}%',
                      style: sSubtitle3Style.copyWith(
                        color: SColorsLight().white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorTheme[2],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                Container(
                  height: 32,
                  width: 107,
                  decoration: BoxDecoration(
                    color: colorTheme[1],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: expanded ? 71 : 55,
                      height: 32,
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 4,
                        left: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorTheme[0],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        ' ${tiers[0].apy}% ',
                        style: sSubtitle3Style.copyWith(
                          color: SColorsLight().white,
                        ),
                      ),
                    ),
                    Container(
                      height: 32,
                      padding: EdgeInsets.only(
                        top: 2,
                        bottom: 4,
                        left: 8,
                        right: expanded ? 32 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: colorTheme[1],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        ' ${tiers[1].apy}% ',
                        style: sSubtitle3Style.copyWith(
                          color: SColorsLight().white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.only(
                          top: 2,
                          bottom: 4,
                          left: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorTheme[2],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          ' ${tiers[2].apy}% ',
                          style: sSubtitle3Style.copyWith(
                            color: SColorsLight().white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}
