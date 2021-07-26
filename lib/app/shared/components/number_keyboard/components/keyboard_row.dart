import 'package:flutter/material.dart';

import 'keyboard_key.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    Key? key,
    required this.key1,
    required this.key2,
    required this.key3,
    required this.onKeyPressed,
  }) : super(key: key);

  final String key1;
  final String key2;
  final String key3;

  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KeyboardKey(
          keyName: key1,
          onKeyPressed: onKeyPressed,
        ),
        KeyboardKey(
          keyName: key2,
          onKeyPressed: onKeyPressed,
        ),
        KeyboardKey(
          keyName: key3,
          onKeyPressed: onKeyPressed,
        ),
      ],
    );
  }
}
