import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum BadgeStatus {
  neutral,
  positive,
  negative,
  disabled,
}

class SBadgeLarge extends StatelessWidget {
  const SBadgeLarge({
    super.key,
    required this.status,
    required this.text,
  });

  final BadgeStatus status;
  final String text;

  @override
  Widget build(BuildContext context) {
    Color getColorByType() {
      switch (status) {
        case BadgeStatus.neutral:
          return SColorsLight().blueExtralight;
        case BadgeStatus.positive:
          return SColorsLight().greenExtralight;
        case BadgeStatus.negative:
          return SColorsLight().redExtralight;
        case BadgeStatus.disabled:
          return SColorsLight().gray2;
      }
    }

    Color getIconColorByType() {
      switch (status) {
        case BadgeStatus.neutral:
          return SColorsLight().blue;
        case BadgeStatus.positive:
          return SColorsLight().green;
        case BadgeStatus.negative:
          return SColorsLight().red;
        case BadgeStatus.disabled:
          return SColorsLight().black;
      }
    }

    return SizedBox(
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          color: getColorByType(),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.only(
          right: 40,
          top: 6,
          bottom: 8,
          left: 8,
        ),
        child: Row(
          children: [
            Assets.svg.medium.checkmarkAlt.simpleSvg(
              color: getIconColorByType(),
              width: 20,
              height: 20,
            ),
            const Spacer(),
            Text(
              text,
              style: STStyles.body1Bold.copyWith(
                color: getIconColorByType(),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
