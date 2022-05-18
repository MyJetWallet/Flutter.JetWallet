import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SimplePercentageIndicator extends StatelessWidget {
  const SimplePercentageIndicator({
    Key? key,
    this.isHot = false,
    required this.tiers,
  }) : super(key: key);

  final List<SimpleTierModel> tiers;
  final bool isHot;

  @override
  Widget build(BuildContext context) {
    final singleTier = tiers.length == 1;
    final doubleTier = tiers.length == 2;
    final colorTheme = isHot
        ? [SColorsLight().orange,
          SColorsLight().brown,
          SColorsLight().darkBrown]
        : [SColorsLight().seaGreen,
          SColorsLight().leafGreen,
          SColorsLight().aquaGreen];

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
          child: Container(
            decoration: BoxDecoration(
              color: tiers[1].active
                  ? colorTheme[1]
                  : SColorsLight().grey5,
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
                      color: tiers[1].active
                          ? colorTheme[1]
                          : SColorsLight().grey5,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      '${tiers[1].apy}%',
                      style: sSubtitle3Style.copyWith(
                        color: tiers[1].active
                            ? SColorsLight().white
                            : SColorsLight().grey3,
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
          child: Container(
            decoration: BoxDecoration(
              color: tiers[2].active
                  ? colorTheme[2]
                  : SColorsLight().grey5,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                Container(
                  height: 32,
                  width: 107,
                  decoration: BoxDecoration(
                    color: tiers[1].active
                        ? colorTheme[1]
                        : SColorsLight().grey5,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 55,
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
                    Container(
                      height: 32,
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 4,
                        left: 8,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: tiers[1].active
                            ? colorTheme[1]
                            : SColorsLight().grey5,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        '${tiers[1].apy}%',
                        style: sSubtitle3Style.copyWith(
                          color: tiers[1].active
                              ? SColorsLight().white
                              : SColorsLight().grey3,
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
                          color: tiers[2].active
                              ? colorTheme[2]
                              : SColorsLight().grey5,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          '${tiers[2].apy}%',
                          style: sSubtitle3Style.copyWith(
                            color: tiers[2].active
                                ? SColorsLight().white
                                : SColorsLight().grey3,
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
