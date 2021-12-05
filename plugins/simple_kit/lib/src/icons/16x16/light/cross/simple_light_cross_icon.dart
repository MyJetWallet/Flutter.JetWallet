import 'package:flutter/material.dart';

import '../../base/simple_base_svg_w16x16.dart';

class SimpleLightCrossIcon extends StatelessWidget {
  const SimpleLightCrossIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgW16X16(
      assetName: 'assets/icons/light/16x16/cross/cross.svg',
      color: color,
    );
  }
}
