import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SBadgeMedium extends StatelessWidget {
  const SBadgeMedium({
    super.key,
    required this.status,
    required this.text,
    this.customIcon,
  });

  final SBadgeType status;
  final String text;
  final Widget? customIcon;

  @override
  Widget build(BuildContext context) {
    Color getColorByType() {
      switch (status) {
        case SBadgeType.neutral:
          return SColorsLight().blueExtralight;
        case SBadgeType.positive:
          return SColorsLight().greenExtralight;
        case SBadgeType.negative:
          return SColorsLight().redExtralight;
        case SBadgeType.archived:
          return SColorsLight().gray2;
      }
    }

    Color getIconColorByType() {
      switch (status) {
        case SBadgeType.neutral:
          return SColorsLight().blue;
        case SBadgeType.positive:
          return SColorsLight().green;
        case SBadgeType.negative:
          return SColorsLight().red;
        case SBadgeType.archived:
          return SColorsLight().black;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: getColorByType(),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customIcon ??
              Assets.svg.medium.checkmarkAlt.simpleSvg(
                color: getIconColorByType(),
                width: 12,
                height: 12,
              ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: STStyles.captionSemibold.copyWith(
                color: getIconColorByType(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
