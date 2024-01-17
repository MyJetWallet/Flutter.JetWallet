import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class OneColumnCell extends StatelessWidget {
  const OneColumnCell({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final SvgGenImage icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        height: 32,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 6,
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
              Text(
                text,
                style: STStyles.body2Medium.copyWith(
                  color: SColorsLight().black,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
