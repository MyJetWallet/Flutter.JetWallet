import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightEarnWithdrawalIcon extends StatelessWidget {
  const SimpleLightEarnWithdrawalIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/earn/earn_withdrawal.svg',
      color: color,
    );
  }
}
