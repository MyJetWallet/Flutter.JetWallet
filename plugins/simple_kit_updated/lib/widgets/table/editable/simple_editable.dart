import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SEditable extends StatelessWidget {
  const SEditable({
    super.key,
    required this.lable,
    this.supplement,
    this.onLeftIconTap,
    this.leftIcon,
    this.rightIcon,
    this.onRightIconTap,
  });

  final String lable;
  final String? supplement;

  final Widget? leftIcon;
  final VoidCallback? onLeftIconTap;
  final Widget? rightIcon;
  final VoidCallback? onRightIconTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leftIcon != null) ...[
            SafeGesture(
              onTap: onLeftIconTap,
              child: leftIcon ?? const SizedBox(),
            ),
            const SizedBox(width: 12),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lable,
                style: STStyles.body2Medium.copyWith(
                  color: colors.gray10,
                ),
              ),
              if (supplement != null)
                Text(
                  supplement ?? '',
                  style: STStyles.subtitle1,
                ),
            ],
          ),
          if (rightIcon != null)
            SafeGesture(
              onTap: onRightIconTap,
              child: rightIcon ?? const SizedBox(),
            ),
        ],
      ),
    );
  }
}
