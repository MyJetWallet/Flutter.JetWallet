import 'package:flutter/material.dart';

import '../../base/simple_base_svg_r16x16.dart';

class SimpleLightTickIcon extends StatelessWidget {
  const SimpleLightTickIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgR16X16(
      assetName: 'assets/icons/light/16x16/tick/tick.svg',
      color: color,
    );
  }
}
