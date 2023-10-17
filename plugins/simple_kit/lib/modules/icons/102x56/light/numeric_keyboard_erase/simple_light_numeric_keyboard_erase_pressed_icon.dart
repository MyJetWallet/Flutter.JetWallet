import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/24x24/base/simple_base_svg_24x24.dart';


class SimpleLightNumericKeyboardErasePressedIcon extends StatelessWidget {
  const SimpleLightNumericKeyboardErasePressedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName:
          'assets/icons/light/102x56/numeric_keyboard_erase/numeric_keyboard_erase_pressed.svg',
      color: color,
    );
  }
}
