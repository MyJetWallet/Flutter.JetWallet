import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SCopyable extends StatelessWidget {
  const SCopyable({
    super.key,
    required this.label,
    required this.value,
    required this.onIconTap,  this.icon,
  });

  final String label;
  final String value;
  final VoidCallback onIconTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: STStyles.body2Medium.copyWith(
                  color: colors.gray10,
                ),
              ),
              Text(
                value,
                style: STStyles.subtitle1,
              ),
            ],
          ),
          SafeGesture(
            onTap: onIconTap,
            child: icon ?? Assets.svg.medium.copy.simpleSvg(
              width: 24,
              height: 24,
              color: colors.gray8,
            ),
          ),
        ],
      ),
    );
  }
}
