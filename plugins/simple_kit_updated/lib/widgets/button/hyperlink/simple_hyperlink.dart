import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SHyperlink extends StatelessWidget {
  const SHyperlink({
    Key? key,
    required this.text,
    this.isDisabled = false,
    this.onTap,
  }) : super(key: key);

  final String text;

  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: SafeGesture(
        onTap: isDisabled ? null : onTap,
        highlightColor: Colors.transparent,
        child: Row(
          children: [
            Text(
              text,
              style: STStyles.body1Semibold.copyWith(
                color: isDisabled ? SColorsLight().gray4 : SColorsLight().black,
              ),
            ),
            const Gap(4),
            SizedBox(
              width: 16,
              height: 16,
              child: Assets.svg.medium.shevronRight.simpleSvg(
                color: isDisabled ? SColorsLight().gray4 : SColorsLight().gray8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
