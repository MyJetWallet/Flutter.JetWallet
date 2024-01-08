import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SChipSuggestion extends HookWidget {
  const SChipSuggestion({
    Key? key,
    required this.leftIcon,
    required this.subTitle,
    required this.title,
    required this.rightValue,
    this.rightIcon,
    this.callback,
  }) : super(key: key);

  final Widget leftIcon;

  final String subTitle;
  final String title;

  final String rightValue;
  final SvgGenImage? rightIcon;

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: callback,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isHighlated.value ? SColorsLight().gray4 : SColorsLight().gray2,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 12,
          right: 8,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: leftIcon,
            ),
            const Gap(8),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .5,
                    maxHeight: 20,
                  ),
                  child: Text(
                    subTitle,
                    style: STStyles.body2Semibold.copyWith(
                      color: SColorsLight().gray10,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .5,
                    maxHeight: 20,
                  ),
                  child: Text(
                    title,
                    style: STStyles.body1Semibold.copyWith(
                      color: SColorsLight().black,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              rightValue,
              style: STStyles.body2Semibold.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
            const Gap(8),
            rightIcon?.simpleSvg(
                  color: SColorsLight().black,
                ) ??
                Assets.svg.medium.shevronRight.simpleSvg(
                  color: SColorsLight().black,
                )
          ],
        ),
      ),
    );
  }
}
