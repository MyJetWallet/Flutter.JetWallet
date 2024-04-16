import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightEyeClosePressedIcon extends StatelessWidget {
  const SimpleLightEyeClosePressedIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/eye_close/eye_close_pressed.svg',
      color: color,
    );
  }
}
