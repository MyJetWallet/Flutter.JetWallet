import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SChipSuggestion extends HookWidget {
  const SChipSuggestion({
    super.key,
    required this.leftIcon,
    required this.subTitle,
    required this.title,
    required this.rightValue,
    this.rightIcon,
    this.callback,
  });

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
      radius: 12,
      highlightColor: SColorsLight().gray4,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: Container(
        width: 327,
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
                      color: callback == null ? SColorsLight().gray8 : SColorsLight().gray10,
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
                      height: 1.4,
                      color: callback == null ? SColorsLight().gray8 : SColorsLight().black,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              rightValue,
              style: STStyles.body2Semibold.copyWith(
                color: callback == null ? SColorsLight().gray8 : SColorsLight().gray10,
              ),
            ),
            const Gap(8),
            rightIcon?.simpleSvg(
                  color: callback == null ? SColorsLight().gray8 : SColorsLight().black,
                ) ??
                Assets.svg.medium.shevronRight.simpleSvg(
                  color: callback == null ? SColorsLight().gray8 : SColorsLight().black,
                )
          ],
        ),
      ),
    );
  }
}
