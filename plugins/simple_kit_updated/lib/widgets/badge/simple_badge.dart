import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum SBadgeSize { l, m, s }

enum SBadgeType { archived, negative, positive, neutral }

class SBadge extends StatelessWidget {
  const SBadge({
    super.key,
    required this.lable,
    this.size = SBadgeSize.l,
    this.type = SBadgeType.positive,
    this.icon,
  });

  final String lable;
  // TODO (Yaroslav): implement resizing
  final SBadgeSize size;
  final SBadgeType type;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: ShapeDecoration(
        color: getBGColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Row(
        children: [
          icon != null ? icon! : SizedBox(),
          Expanded(
            child: Text(
              lable,
              style: STStyles.body1Bold.copyWith(
                color: getMainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: icon != null ? 20 : 0),
        ],
      ),
    );
  }

  Color get getBGColor {
    final colors = SColorsLight();
    switch (type) {
      case SBadgeType.archived:
        return colors.gray2;
      case SBadgeType.negative:
        return colors.redExtralight;
      case SBadgeType.positive:
        return colors.greenExtralight;
      case SBadgeType.neutral:
        return colors.blueExtralight;
      default:
        return colors.blueExtralight;
    }
  }

  Color get getMainColor {
    final colors = SColorsLight();
    switch (type) {
      case SBadgeType.archived:
        return colors.gray8;
      case SBadgeType.negative:
        return colors.red;
      case SBadgeType.positive:
        return colors.green;
      case SBadgeType.neutral:
        return colors.blue;
      default:
        return colors.blue;
    }
  }
}
