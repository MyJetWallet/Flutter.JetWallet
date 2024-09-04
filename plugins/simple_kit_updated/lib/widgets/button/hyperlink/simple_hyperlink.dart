import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SHyperlink extends StatelessWidget {
  const SHyperlink({
    super.key,
    required this.text,
    this.isDisabled = false,
    this.onTap,
  });

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
            Assets.svg.medium.shevronRight.simpleSvg(
              width: 16,
              height: 16,
              color: isDisabled ? SColorsLight().gray4 : SColorsLight().gray8,
            ),
          ],
        ),
      ),
    );
  }
}
