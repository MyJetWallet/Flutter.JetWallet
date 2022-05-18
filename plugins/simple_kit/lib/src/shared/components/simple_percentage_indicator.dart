import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SimplePercentageIndicator extends StatelessWidget {
  const SimplePercentageIndicator({
    Key? key,
    this.expanded = false,
    required this.tiers,
  }) : super(key: key);

  final List<SimpleTierModel> tiers;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final singleTier = tiers.length == 1;
    final doubleTier = tiers.length == 2;

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
              color: SColorsLight().seaGreen,
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
                  ? SColorsLight().leafGreen
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
                      color: SColorsLight().seaGreen,
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
                          ? SColorsLight().leafGreen
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
                  ? SColorsLight().aquaGreen
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
                        ? SColorsLight().leafGreen
                        : SColorsLight().grey5,
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
                        color: SColorsLight().seaGreen,
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
                      padding: EdgeInsets.only(
                        top: 2,
                        bottom: 4,
                        left: 8,
                        right: expanded ? 32 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: tiers[1].active
                            ? SColorsLight().leafGreen
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
                              ? SColorsLight().aquaGreen
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
