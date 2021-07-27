import 'package:flutter/material.dart';

import 'keyboard_key.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    Key? key,
    this.realKey1,
    this.realKey2,
    this.realKey3,
    required this.frontKey1,
    required this.frontKey2,
    required this.frontKey3,
    required this.onKeyPressed,
  }) : super(key: key);

  final String? realKey1;
  final String? realKey2;
  final String? realKey3;
  final String frontKey1;
  final String frontKey2;
  final String frontKey3;

  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KeyboardKey(
          realKey: realKey1,
          frontKey: frontKey1,
          onKeyPressed: onKeyPressed,
        ),
        KeyboardKey(
          realKey: realKey2,
          frontKey: frontKey2,
          onKeyPressed: onKeyPressed,
        ),
        KeyboardKey(
          realKey: realKey3,
          frontKey: frontKey3,
          onKeyPressed: onKeyPressed,
        ),
      ],
    );
  }
}
