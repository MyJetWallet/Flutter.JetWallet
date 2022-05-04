import 'package:flutter/material.dart';

import '../../base/simple_base_svg_14x16.dart';

class SimpleLightStartIcon extends StatelessWidget {
  const SimpleLightStartIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg14X16(
      assetName: 'assets/icons/light/14x16/start/start.svg',
      color: color,
    );
  }
}
