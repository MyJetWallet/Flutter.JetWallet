import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
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
    Key? key,
    required this.child,
    required this.backgroundColor,
    this.border,
    this.callback,
    this.onHighlightChanged,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final BoxBorder? border;

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
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
