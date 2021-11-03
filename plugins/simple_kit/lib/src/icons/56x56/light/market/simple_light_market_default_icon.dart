import 'package:flutter/material.dart';

import '../../base/simple_base_svg_56x56.dart';

class SimpleLightMarketDefaultIcon extends StatelessWidget {
  const SimpleLightMarketDefaultIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg56X56(
      assetName: 'assets/icons/light/56x56/market/market_default.svg',
      color: color,
    );
  }
}
