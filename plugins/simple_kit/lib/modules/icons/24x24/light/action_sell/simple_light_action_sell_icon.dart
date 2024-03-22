import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightActionSellIcon extends StatelessWidget {
  const SimpleLightActionSellIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/action_sell/action_sell.svg',
      color: color,
    );
  }
}
