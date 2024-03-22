import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightArrowDownIcon extends StatelessWidget {
  const SimpleLightArrowDownIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: SimpleBaseSvg24X24(
        assetName: 'assets/icons/light/24x24/big_arrow/arrow_up.svg',
        color: color,
      ),
    );
  }
}
