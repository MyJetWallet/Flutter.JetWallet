import 'package:flutter/material.dart';

import '../../base/simple_base_svg_r16x16.dart';

class SimpleLightSmileNeutralIcon extends StatelessWidget {
  const SimpleLightSmileNeutralIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgR16X16(
      assetName: 'assets/icons/light/16x16/smiles/smile_neutral.svg',
      color: color,
    );
  }
}
