import 'package:flutter/material.dart';

import '../../base/simple_base_svg_r24x24.dart';

class SimpleLightTouchAndPinIcon extends StatelessWidget {
  const SimpleLightTouchAndPinIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgR24X24(
      assetName: 'assets/icons/light/24x24/touch_and_pin/touch_and_pin.svg',
      color: color,
    );
  }
}
