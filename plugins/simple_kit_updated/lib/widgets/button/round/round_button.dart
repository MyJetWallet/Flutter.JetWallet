import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class RoundButton extends HookWidget {
  const RoundButton({
    Key? key,
    required this.value,
    this.onTap,
    this.width,
    this.isDisabled = false,
  }) : super(key: key);

  final bool isDisabled;
  final String value;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    return Material(
      color: Colors.transparent,
      child: SafeGesture(
        highlightColor: Colors.transparent,
        onTap: isDisabled ? null : onTap,
        onHighlightChanged: (p0) {
          isHighlated.value = p0;
        },
        radius: 22,
        child: Ink(
          height: 44,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: isHighlated.value ? SColorsLight().gray4 : SColorsLight().gray2),
            borderRadius: BorderRadius.circular(22),
            color: isHighlated.value ? SColorsLight().gray2 : SColorsLight().white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Center(
              child: Text(
                value,
                style: STStyles.subtitle1.copyWith(
                  height: 1,
                  leadingDistribution: TextLeadingDistribution.even,
                  color: isDisabled ? SColorsLight().gray6 : SColorsLight().black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
