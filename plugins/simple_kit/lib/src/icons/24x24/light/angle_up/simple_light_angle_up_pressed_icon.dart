import 'package:flutter/material.dart';

import '../../base/simple_base_svg_r24x24.dart';

class SimpleLightAngleUpPressedIcon extends StatelessWidget {
  const SimpleLightAngleUpPressedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgR24X24(
      assetName: 'assets/icons/light/24x24/angle_up/angle_up_pressed.svg',
      color: color,
    );
  }
}
