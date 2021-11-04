import 'package:flutter/material.dart';

import '../../base/simple_base_svg_r24x24.dart';

class SimpleLightBigArrowNegativeIcon extends StatelessWidget {
  const SimpleLightBigArrowNegativeIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgR24X24(
      assetName: 'assets/icons/light/24x24/big_arrow/big_arrow_negative.svg',
      color: color,
    );
  }
}
