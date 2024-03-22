import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import 'keys/keyboard_icon.dart';
import 'keys/keyboard_key.dart';

/// icon or frontKey must be provided but not both
class NumericKeyboardRow extends StatelessWidget {
  const NumericKeyboardRow({
    super.key,
    this.icon1,
    this.icon2,
    this.icon3,
    this.iconPressed1,
    this.iconPressed2,
    this.iconPressed3,
    this.hideIcon1,
    this.frontKey1,
    this.frontKey2,
    this.frontKey3,
    required this.realValue1,
    required this.realValue2,
    required this.realValue3,
    required this.onKeyPressed,
  });

  final Widget? icon1;
  final Widget? icon2;
  final Widget? icon3;
  final Widget? iconPressed1;
  final Widget? iconPressed2;
  final Widget? iconPressed3;
  final bool? hideIcon1;
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
          KeyboardIcon(
            hide: hideIcon1 ?? false,
            realValue: realValue1,
            onPressed: onKeyPressed,
            activeIcon: icon1,
            pressedIcon: iconPressed1,
          ),
        const SpaceW10(),
        if (frontKey2 != null)
          KeyboardKey(
            realValue: realValue2,
            frontKey: frontKey2!,
            onKeyPressed: onKeyPressed,
          )
        else
          KeyboardIcon(
            realValue: realValue2,
            onPressed: onKeyPressed,
            activeIcon: icon2,
            pressedIcon: iconPressed2,
          ),
        const SpaceW10(),
        if (frontKey3 != null)
          KeyboardKey(
            realValue: realValue3,
            frontKey: frontKey3!,
            onKeyPressed: onKeyPressed,
          )
        else
          KeyboardIcon(
            realValue: realValue3,
            onPressed: onKeyPressed,
            activeIcon: icon3,
            pressedIcon: iconPressed3,
          ),
      ],
    );
  }
}
