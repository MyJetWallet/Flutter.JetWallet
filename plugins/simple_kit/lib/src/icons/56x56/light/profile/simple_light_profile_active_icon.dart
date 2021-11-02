import 'package:flutter/material.dart';

import '../../base/simple_base_svg_56x56.dart';

class SimpleLightProfileActiveIcon extends StatelessWidget {
  const SimpleLightProfileActiveIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg56X56(
      assetName: 'assets/icons/light/56x56/profile/profile_active.svg',
      color: color,
    );
  }
}
