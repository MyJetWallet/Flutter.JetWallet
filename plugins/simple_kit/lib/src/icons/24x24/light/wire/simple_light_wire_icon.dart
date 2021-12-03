import 'package:flutter/material.dart';

import '../../base/simple_base_svg_w24x24.dart';

class SimpleLightWireIcon extends StatelessWidget {
  const SimpleLightWireIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgW24X24(
      assetName: 'assets/icons/light/24x24/wire/wire.svg',
      color: color,
    );
  }
}
