import 'package:flutter/material.dart';

import 'keys/keyboard_button.dart';
import 'keys/keyboard_key.dart';

/// child or frontKey must be provided but not both
class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    Key? key,
    this.child1,
    this.child2,
    this.child3,
    this.hideChild1,
    this.frontKey1,
    this.frontKey2,
    this.frontKey3,
    required this.realValue1,
    required this.realValue2,
    required this.realValue3,
    required this.onKeyPressed,
  }) : super(key: key);

  final Widget? child1;
  final Widget? child2;
  final Widget? child3;
  final bool? hideChild1;
  final String? frontKey1;
  final String? frontKey2;
  final String? frontKey3;
  final String realValue1;
  final String realValue2;
  final String realValue3;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (frontKey1 != null)
          KeyboardKey(
            realValue: realValue1,
            frontKey: frontKey1!,
            onKeyPressed: onKeyPressed,
          )
        else
          KeyboardButton(
            hideChild: hideChild1 ?? false,
            realValue: realValue1,
            onPressed: onKeyPressed,
            child: child1,
          ),
        if (frontKey2 != null)
          KeyboardKey(
            realValue: realValue2,
            frontKey: frontKey2!,
            onKeyPressed: onKeyPressed,
          )
        else
          KeyboardButton(
            realValue: realValue2,
            onPressed: onKeyPressed,
            child: child2,
          ),
        if (frontKey3 != null)
          KeyboardKey(
            realValue: realValue3,
            frontKey: frontKey3!,
            onKeyPressed: onKeyPressed,
          )
        else
          KeyboardButton(
            realValue: realValue3,
            onPressed: onKeyPressed,
            child: child3,
          ),
      ],
    );
  }
}
