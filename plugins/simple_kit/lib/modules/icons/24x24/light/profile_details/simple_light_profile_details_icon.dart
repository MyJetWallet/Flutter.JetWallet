import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightProfileDetailsIcon extends StatelessWidget {
  const SimpleLightProfileDetailsIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/profile/profile_details/profile_details.svg',
      color: color,
    );
  }
}
