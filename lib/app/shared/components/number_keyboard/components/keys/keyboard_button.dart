import 'package:flutter/material.dart';

import 'components/keyboard_key_detector.dart';
import 'components/keyboard_key_size.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    this.child,
    this.hideChild,
    required this.realValue,
    required this.onPressed,
  });

  final Widget? child;
  final bool? hideChild;

  /// The value that will be returned onPressed
  final String realValue;
  final void Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return KeyboardKeySize(
      child: hideChild ?? false
          ? const SizedBox()
          : KeyboardKeyDetector(
              onTap: () => onPressed(realValue),
              child: child,
            ),
    );
  }
}
