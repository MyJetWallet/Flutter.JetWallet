import 'package:flutter/material.dart';

import '../../base/simple_base_svg_20x20.dart';

class SimpleLightDepositInProgressEarnIcon extends StatelessWidget {
  const SimpleLightDepositInProgressEarnIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/deposit_in_progress/progress_earn_icon.svg',
      color: color,
    );
  }
}
