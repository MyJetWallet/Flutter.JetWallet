import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SEditable extends HookWidget {
  const SEditable({
    super.key,
    required this.lable,
    this.supplement,
    this.onLeftIconTap,
    this.leftIcon,
    this.rightIcon,
    this.onRightIconTap,
    this.onCardTap,
    this.lableStyle,
    this.supplementStyle,
  });

  final String lable;
  final String? supplement;

  final TextStyle? lableStyle;
  final TextStyle? supplementStyle;

  final Widget? leftIcon;
  final VoidCallback? onLeftIconTap;
  final Widget? rightIcon;
  final VoidCallback? onRightIconTap;

  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    final colors = SColorsLight();
    return SafeGesture(
      onTap: onCardTap,
      highlightColor: SColorsLight().gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: isHighlated.value ? SColorsLight().gray2 : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leftIcon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SafeGesture(
                  onTap: onLeftIconTap,
                  child: leftIcon ?? const SizedBox(),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lable,
                    style: lableStyle ?? STStyles.subtitle1,
                  ),
                  if (supplement != null)
                    Text(
                      supplement ?? '',
                      style: supplementStyle ??
                          STStyles.body2Medium.copyWith(
                            color: colors.gray10,
                          ),
                    ),
                ],
              ),
            ),
            if (rightIcon != null)
              SafeGesture(
                onTap: onRightIconTap,
                child: rightIcon ?? const SizedBox(),
              ),
          ],
        ),
      ),
    );
  }
}
