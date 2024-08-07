import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

enum ButtonType {
  blue,
  black,
  text,
  red,
  outlined,
}

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.border,
    this.borderRadius,
    this.callback,
    this.onHighlightChanged,
    this.padding,
  });

  final Widget child;
  final Color backgroundColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;

  final VoidCallback? callback;
  final Function(bool)? onHighlightChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeGesture(
        onTap: callback,
        highlightColor: Colors.transparent,
        onHighlightChanged: onHighlightChanged,
        radius: 16,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: border,
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
          child: child,
        ),
      ),
    );
  }
}
