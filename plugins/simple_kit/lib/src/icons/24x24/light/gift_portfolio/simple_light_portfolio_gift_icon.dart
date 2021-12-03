import 'package:flutter/material.dart';

import '../../base/simple_base_svg_w24x24.dart';

class SimpleLightGiftPortfolioIcon extends StatelessWidget {
  const SimpleLightGiftPortfolioIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgW24X24(
      assetName: 'assets/icons/light/24x24/gift_portfolio/gift_portfolio.svg',
      color: color,
    );
  }
}
