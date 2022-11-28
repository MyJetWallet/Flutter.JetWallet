import 'package:flutter/material.dart';

import '../../base/simple_base_svg_56x56.dart';

class SimpleLightPortfolioActiveIcon extends StatelessWidget {
  const SimpleLightPortfolioActiveIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg56X56(
      assetName: 'assets/icons/light/56x56/portfolio/portfolio_active.svg',
      color: color,
    );
  }
}
