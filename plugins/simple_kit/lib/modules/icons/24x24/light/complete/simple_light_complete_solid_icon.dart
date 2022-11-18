import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightCompleteSolidIcon extends StatelessWidget {
  const SimpleLightCompleteSolidIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/complete/complete_solid.svg',
      color: color,
    );
  }
}
