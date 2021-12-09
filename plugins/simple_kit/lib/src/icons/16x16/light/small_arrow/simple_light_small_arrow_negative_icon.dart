import 'package:flutter/material.dart';

import '../../base/simple_base_svg_16x16.dart';

class SimpleLightSmallArrowNegativeIcon extends StatelessWidget {
  const SimpleLightSmallArrowNegativeIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg16X16(
      assetName:
          'assets/icons/light/16x16/small_arrow/small_arrow_negative.svg',
      color: color,
    );
  }
}
