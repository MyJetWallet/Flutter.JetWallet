import 'package:flutter/material.dart';

import '../../base/simple_base_svg_16x16.dart';

class SimpleLightStatsIcon extends StatelessWidget {
  const SimpleLightStatsIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg13X14(
      assetName: 'assets/icons/light/13x14/stats/stats.svg',
      color: color,
    );
  }
}
