import 'package:flutter/material.dart';

import '../../base/simple_base_svg_56x56.dart';

class SimpleLightPortfolioDefaultIcon extends StatelessWidget {
  const SimpleLightPortfolioDefaultIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg56X56(
      assetName: 'assets/icons/light/56x56/portfolio/portfolio_default.svg',
      color: color,
    );
  }
}
