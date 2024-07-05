import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SCopyable extends StatelessWidget {
  const SCopyable({
    super.key,
    required this.lable,
    required this.value,
    required this.onIconTap,
  });

  final String lable;
  final String value;
  final VoidCallback onIconTap;

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
                lable,
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
            child: Assets.svg.medium.copy.simpleSvg(
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
