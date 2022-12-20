import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightBuytWithCashIcon extends StatelessWidget {
  const SimpleLightBuytWithCashIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName:
          'assets/icons/light/24x24/action_buy_with_cash/action_buy_with_cash.svg',
      color: color,
    );
  }
}
