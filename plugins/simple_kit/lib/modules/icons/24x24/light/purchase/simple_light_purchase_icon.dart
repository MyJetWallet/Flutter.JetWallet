import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightPurchaseIcon extends StatelessWidget {
  const SimpleLightPurchaseIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName:
          'assets/icons/light/24x24/purchase/simple_purchase.svg',
      color: color,
    );
  }
}
