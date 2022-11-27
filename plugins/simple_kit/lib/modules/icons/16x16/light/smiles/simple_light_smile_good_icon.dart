import 'package:flutter/material.dart';

import '../../base/simple_base_svg_16x16.dart';

class SimpleLightSmileGoodIcon extends StatelessWidget {
  const SimpleLightSmileGoodIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg16X16(
      assetName: 'assets/icons/light/16x16/smiles/smile_good.svg',
      color: color,
    );
  }
}
