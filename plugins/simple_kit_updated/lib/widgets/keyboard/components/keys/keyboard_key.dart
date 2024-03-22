import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'components/keyboard_key_detector.dart';
import 'components/keyboard_key_size.dart';

class KeyboardKey extends StatefulWidget {
  const KeyboardKey({
    super.key,
    required this.realValue,
    required this.frontKey,
    required this.onKeyPressed,
  });

  /// The value that will be returned onPressed
  final String realValue;

  /// The key that will be showed to the user
  final String frontKey;
  final void Function(String) onKeyPressed;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardKeySize(
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: !highlighted ? SColorsLight().white : SColorsLight().gray2,
          shape: const CircleBorder(),
        ),
        child: KeyboardKeyDetector(
          onTap: () => widget.onKeyPressed(widget.realValue),
          onHighlightChanged: (value) {
            setState(() {
              highlighted = value;
            });
          },
          child: Center(
            child: Text(
              widget.frontKey,
              style: STStyles.header5.copyWith(
                color: highlighted ? SColorsLight().black.withOpacity(0.8) : SColorsLight().black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
