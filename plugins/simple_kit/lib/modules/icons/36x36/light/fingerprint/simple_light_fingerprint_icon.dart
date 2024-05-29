import 'package:flutter/material.dart';

import '../../base/simple_base_svg_36x36.dart';

class SimpleLightFingerprintIcon extends StatelessWidget {
  const SimpleLightFingerprintIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg36X36(
      assetName: 'assets/icons/light/36x36/fingerprint/fingerprint.svg',
      color: color,
    );
  }
}
