import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightInfoPressedIcon extends StatelessWidget {
  const SimpleLightInfoPressedIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/info/info_pressed.svg',
      color: color,
    );
  }
}
