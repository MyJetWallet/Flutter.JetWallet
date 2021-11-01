import 'package:flutter/material.dart';

import '../../base/simple_base_svg_102x56.dart';

class SimpleLightNumericKeyboardErasePressedIcon extends StatelessWidget {
  const SimpleLightNumericKeyboardErasePressedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg102X56(
      assetName:
          'assets/icons/light/102x56/numeric_keyboard_erase/numeric_keyboard_erase_pressed.svg',
      color: color,
    );
  }
}
