import 'package:flutter/material.dart';

import '../../base/simple_base_svg_20x20.dart';

class SimpleLightClockIcon extends StatelessWidget {
  const SimpleLightClockIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/deposit_in_progress/clock.svg',
      color: color,
    );
  }
}
