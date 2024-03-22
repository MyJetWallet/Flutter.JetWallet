import 'package:flutter/material.dart';

import '../../base/simple_base_svg_56x56.dart';

class SimpleLightEarnDefaultIcon extends StatelessWidget {
  const SimpleLightEarnDefaultIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg56X56(
      assetName: 'assets/icons/light/56x56/earn/earn_default.svg',
      color: color,
    );
  }
}
