import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

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
