import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

final _baseButtonRadius = BorderRadius.circular(16.0);

class SimpleBaseButton extends StatelessWidget {
  const SimpleBaseButton({
    Key? key,
    this.icon,
    this.onTap,
    required this.onHighlightChanged,
    required this.decoration,
    required this.name,
    required this.nameColor,
  }) : super(key: key);

  final Widget? icon;
  final Function()? onTap;
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
          baseline: 34.0,
          baselineType: TextBaseline.alphabetic,
          child: SPaddingH24(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
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
