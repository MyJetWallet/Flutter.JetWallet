import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightPastePressedIcon extends StatelessWidget {
  const SimpleLightPastePressedIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/paste/paste_pressed.svg',
      color: color,
    );
  }
}
