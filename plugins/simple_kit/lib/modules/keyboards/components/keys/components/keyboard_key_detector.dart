import 'package:flutter/material.dart';

class KeyboardKeyDetector extends StatelessWidget {
  const KeyboardKeyDetector({
    super.key,
    this.child,
    required this.onTap,
    required this.onHighlightChanged,
  });

  final Widget? child;
  final Function() onTap;
  final Function(bool) onHighlightChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHighlightChanged: onHighlightChanged,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: child,
    );
  }
}
