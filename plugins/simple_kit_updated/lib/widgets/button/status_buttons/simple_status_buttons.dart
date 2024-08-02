import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum SStatusButtonsType { blue, yellow, green, red }

class SStatusButtons extends StatelessWidget {
  const SStatusButtons({
    super.key,
    required this.type,
    required this.label,
  });

  final SStatusButtonsType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: getBGColorByType(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Assets.svg.medium.verify.simpleSvg(
              color: getColorByType(),
            ),
          ),
          const Gap(12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .7,
            ),
            child: Text(
              label,
              style: STStyles.subtitle1.copyWith(
                color: getColorByType(),
              ),
            ),
          ),
          const Spacer(),
          Assets.svg.medium.shevronRight.simpleSvg(
            color: getColorByType(),
          ),
        ],
      ),
    );
  }

  Color getColorByType() {
    switch (type) {
      case SStatusButtonsType.blue:
        return SColorsLight().blue;
      case SStatusButtonsType.yellow:
        return SColorsLight().yellowDark;
      case SStatusButtonsType.green:
        return SColorsLight().green;
      case SStatusButtonsType.red:
        return SColorsLight().red;
    }
  }

  Color getBGColorByType() {
    switch (type) {
      case SStatusButtonsType.blue:
        return SColorsLight().blueExtralight;
      case SStatusButtonsType.yellow:
        return SColorsLight().yellowExtralight;
      case SStatusButtonsType.green:
        return SColorsLight().greenExtralight;
      case SStatusButtonsType.red:
        return SColorsLight().redExtralight;
    }
  }
}
