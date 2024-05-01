import 'package:flutter/material.dart';

import '../../base/simple_base_svg_18x18.dart';

class SimpleLightEarnDepositIcon extends StatelessWidget {
  const SimpleLightEarnDepositIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg18x18(
      assetName: 'assets/icons/light/18x18/earn_deposit/earn_deposit.svg',
      color: color,
    );
  }
}
