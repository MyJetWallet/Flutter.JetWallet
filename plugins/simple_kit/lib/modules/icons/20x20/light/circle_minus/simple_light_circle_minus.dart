import 'package:flutter/material.dart';

import '../../base/simple_base_svg_20x20.dart';

class SimpleLightCircleMinusIcon extends StatelessWidget {
  const SimpleLightCircleMinusIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/circle_minus/circle_minus.svg',
      color: color,
    );
  }
}
