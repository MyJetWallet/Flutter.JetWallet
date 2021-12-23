import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

final _baseButtonRadius = BorderRadius.circular(16.0);

class SimpleBaseButton extends StatelessWidget {
  const SimpleBaseButton({
    Key? key,
    this.icon,
    this.onTap,
    this.addIconPadding = true,
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
  final bool addIconPadding;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              if (addIconPadding) const SpaceW10(),
            ],
            Text(
              name,
              style: sButtonTextStyle.copyWith(
                color: nameColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
