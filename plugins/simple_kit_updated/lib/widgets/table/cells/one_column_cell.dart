import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class OneColumnCell extends StatelessWidget {
  const OneColumnCell({
    Key? key,
    required this.icon,
    required this.text,
    this.needHorizontalPading = true,
  }) : super(key: key);

  final SvgGenImage icon;
  final String text;
  final bool needHorizontalPading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: needHorizontalPading ? 24 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon.simpleSvg(
            width: 20,
            height: 20,
          ),
          const Gap(12),
          Flexible(
            child: Text(
              text,
              style: STStyles.body2Medium.copyWith(
                color: SColorsLight().black,
              ),
              maxLines: 12,
            ),
          ),
        ],
      ),
    );
  }
}
