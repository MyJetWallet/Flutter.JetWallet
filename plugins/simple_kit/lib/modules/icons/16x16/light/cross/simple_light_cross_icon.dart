import 'package:flutter/material.dart';

import '../../base/simple_base_svg_16x16.dart';

class SimpleLightCrossIcon extends StatelessWidget {
  const SimpleLightCrossIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg16X16(
      assetName: 'assets/icons/light/16x16/cross/cross.svg',
      color: color,
    );
  }
}
