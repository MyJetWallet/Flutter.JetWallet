import 'package:flutter/material.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

final _baseButtonRadius = BorderRadius.circular(16.0);

class SimpleBaseButton extends StatelessWidget {
  const SimpleBaseButton({
    Key? key,
    this.icon,
    this.onTap,
    this.baseline = 33.5,
    required this.onHighlightChanged,
    required this.decoration,
    required this.name,
    required this.nameColor,
  }) : super(key: key);

  final Widget? icon;
  final Function()? onTap;
  final double baseline;
  final Function(bool) onHighlightChanged;
  final BoxDecoration decoration;
  final String name;
  final Color nameColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHighlightChanged: onHighlightChanged,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: _baseButtonRadius,
      child: Ink(
        height: 56.0,
        decoration: decoration.copyWith(
          borderRadius: _baseButtonRadius,
        ),
        child: Baseline(
          baseline: baseline,
          baselineType: TextBaseline.alphabetic,
          child: SPaddingH24(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: 23,
                    child: icon,
                  ),
                  const SpaceW10(),
                ],
                Flexible(
                  child: Text(
                    name,
                    style: sButtonTextStyle.copyWith(
                      color: nameColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
