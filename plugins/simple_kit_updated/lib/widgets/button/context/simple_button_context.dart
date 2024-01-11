import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

enum SButtonContextType {
  basic,
  basicInverted,
  iconedSmall,
  iconedSmallInverted,
  iconedMedium,
  iconedMediumInverted,
  iconedLarge,
  iconedLargeInverted,
}

Set<SButtonContextType> _invertedButtonContextTypes = {
  SButtonContextType.basicInverted,
  SButtonContextType.iconedSmallInverted,
  SButtonContextType.iconedMediumInverted,
  SButtonContextType.iconedLargeInverted,
};

Set<SButtonContextType> _withIconButtonContextTypes = {
  SButtonContextType.iconedLarge,
  SButtonContextType.iconedMedium,
  SButtonContextType.iconedSmall,
  SButtonContextType.iconedLargeInverted,
  SButtonContextType.iconedMediumInverted,
  SButtonContextType.iconedSmallInverted,
};

class SButtonContext extends StatelessWidget {
  const SButtonContext({
    Key? key,
    required this.type,
    required this.text,
    this.onTap,
    this.isDisabled = false,
    this.contentColor,
    this.backgroundColor,
    this.icon,
    this.iconCustomColor,
  }) : super(key: key);

  final SButtonContextType type;
  final String text;
  final VoidCallback? onTap;
  final bool isDisabled;
  final Color? contentColor;
  final Color? backgroundColor;
  final SvgGenImage? icon;
  final Color? iconCustomColor;

  @override
  Widget build(BuildContext context) {
    double getHeightOnType() {
      switch (type) {
        case SButtonContextType.basic:
          return 40;
        case SButtonContextType.basicInverted:
          return 40;
        case SButtonContextType.iconedSmall:
          return 40;
        case SButtonContextType.iconedMedium:
          return 48;
        case SButtonContextType.iconedLarge:
          return 56;
        default:
          return 40;
      }
    }

    EdgeInsetsGeometry getPaddingOnType() {
      switch (type) {
        case SButtonContextType.basic:
          return const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          );
        case SButtonContextType.basicInverted:
          return const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          );
        case SButtonContextType.iconedSmall:
          return const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 16,
            right: 20,
          );
        case SButtonContextType.iconedMedium:
          return const EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 16,
            right: 24,
          );
        case SButtonContextType.iconedLarge:
          return const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 16,
            right: 20,
          );
        default:
          return const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          );
      }
    }

    // Material нужен, чтобы работал inkwell ripple effect
    return Material(
      color: Colors.white.withOpacity(0),
      child: SafeGesture(
        radius: 12,
        onTap: isDisabled ? null : onTap,
        highlightColor: SColorsLight().gray4,
        child: Ink(
          height: getHeightOnType(),
          decoration: BoxDecoration(
            color: backgroundColor ??
                (_invertedButtonContextTypes.contains(type) ? Colors.transparent : SColorsLight().gray2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: getPaddingOnType(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_withIconButtonContextTypes.contains(type)) ...[
                  SizedBox(
                    width: type == SButtonContextType.iconedLarge ? 24 : 20,
                    height: type == SButtonContextType.iconedLarge ? 24 : 20,
                    child: icon?.simpleSvg(
                          color: isDisabled ? SColorsLight().gray8 : iconCustomColor ?? SColorsLight().blue,
                        ) ??
                        Assets.svg.medium.add.simpleSvg(
                          color: isDisabled ? SColorsLight().gray8 : SColorsLight().blue,
                        ),
                  ),
                  const Gap(8),
                ],
                Text(
                  text,
                  style: type == SButtonContextType.iconedLarge
                      ? STStyles.button.copyWith(
                          color: contentColor ??
                              (isDisabled ? SColorsLight().gray8 : iconCustomColor ?? SColorsLight().blue),
                          height: 1,
                        )
                      : STStyles.body1Bold.copyWith(
                          color: contentColor ??
                              (isDisabled ? SColorsLight().gray8 : iconCustomColor ?? SColorsLight().blue),
                          height: 1,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
