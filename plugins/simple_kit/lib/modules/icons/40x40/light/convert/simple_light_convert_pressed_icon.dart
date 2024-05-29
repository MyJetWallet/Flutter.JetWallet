import 'package:flutter/material.dart';

import '../../base/simple_base_svg_40x40.dart';

class SimpleLightConvertPressedIcon extends StatelessWidget {
  const SimpleLightConvertPressedIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg40X40(
      assetName: 'assets/icons/light/40x40/convert/convert_pressed.svg',
      color: color,
    );
  }
}
