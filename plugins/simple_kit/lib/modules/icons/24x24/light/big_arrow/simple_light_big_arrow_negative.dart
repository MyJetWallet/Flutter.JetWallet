import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightBigArrowNegativeIcon extends StatelessWidget {
  const SimpleLightBigArrowNegativeIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/big_arrow/big_arrow_negative.svg',
      color: color,
    );
  }
}
