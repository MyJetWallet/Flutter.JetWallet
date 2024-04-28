import 'package:flutter/material.dart';

import '../../base/simple_base_svg_16x16.dart';

class SimpleLightTickIcon extends StatelessWidget {
  const SimpleLightTickIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg16X16(
      assetName: 'assets/icons/light/16x16/tick/tick.svg',
      color: color,
    );
  }
}
