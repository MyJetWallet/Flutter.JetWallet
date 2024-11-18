import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SLinkLabel extends StatelessWidget {
  const SLinkLabel({
    required this.title,
    required this.onTap,
    super.key,
  });
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: STStyles.subtitle1.copyWith(color: colors.black),
          ),
          SizedBox(
            width: 16,
            height: 16,
            child: Assets.svg.medium.shevronRight.simpleSvg(),
          ),
        ],
      ),
    );
  }
}
