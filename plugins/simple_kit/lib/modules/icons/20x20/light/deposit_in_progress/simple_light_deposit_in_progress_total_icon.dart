import 'package:flutter/material.dart';

import '../../base/simple_base_svg_20x20.dart';

class SimpleLightDepositInProgressTotalIcon extends StatelessWidget {
  const SimpleLightDepositInProgressTotalIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/deposit_in_progress/progress_total_icon.svg',
      color: color,
    );
  }
}
