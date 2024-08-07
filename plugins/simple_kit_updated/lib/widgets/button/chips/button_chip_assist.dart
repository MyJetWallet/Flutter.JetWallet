import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ButtonChipAssist extends HookWidget {
  const ButtonChipAssist({
    super.key,
    required this.leftIcon,
    required this.text,
    required this.rightText,
    this.rightIcon,
    this.callback,
  });

  final SvgGenImage leftIcon;
  final SvgGenImage? rightIcon;

  final String text;
  final String rightText;

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: callback,
      highlightColor: SColorsLight().gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: SizedBox(
        height: 56,
        child: ColoredBox(
          color: isHighlated.value ? SColorsLight().gray2 : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFFE0E4EA)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    leftIcon.simpleSvg(
                      color: SColorsLight().gray10,
                    ),
                    const Gap(8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .5,
                      ),
                      child: Text(
                        text,
                        style: STStyles.body1Semibold.copyWith(
                          color: SColorsLight().gray10,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      rightText,
                      style: STStyles.body2Semibold,
                    ),
                    if (rightIcon != null) ...[
                      const Gap(8),
                      rightIcon!.simpleSvg(
                        color: SColorsLight().gray10,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
