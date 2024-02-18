import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

enum SBadgeStatus { neutral, positive, negative }

class SBadge extends StatelessWidget {
  const SBadge({
    Key? key,
    required this.status,
    required this.text,
  }) : super(key: key);

  final SBadgeStatus status;
  final String text;

  @override
  Widget build(BuildContext context) {
    Color getColorByType() {
      switch (status) {
        case SBadgeStatus.neutral:
          return SColorsLight().blueExtralight;
        case SBadgeStatus.positive:
          return SColorsLight().greenExtralight;
        case SBadgeStatus.negative:
          return SColorsLight().redExtralight;
      }
    }

    Color getIconColorByType() {
      switch (status) {
        case SBadgeStatus.neutral:
          return SColorsLight().blue;
        case SBadgeStatus.positive:
          return SColorsLight().green;
        case SBadgeStatus.negative:
          return SColorsLight().red;
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
          bottom: 6,
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
