import 'package:flutter/material.dart';

import '../../base/simple_base_svg_36x36.dart';

class SimpleLightKeyboardEraseIcon extends StatelessWidget {
  const SimpleLightKeyboardEraseIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg36X36(
      assetName: 'assets/icons/light/36x36/keyboard_erase/keyboard_erase.svg',
      color: color,
    );
  }
}
