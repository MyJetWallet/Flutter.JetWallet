import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightActionDepositIcon extends StatelessWidget {
  const SimpleLightActionDepositIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/action_deposit/action_deposit.svg',
      color: color,
    );
  }
}
