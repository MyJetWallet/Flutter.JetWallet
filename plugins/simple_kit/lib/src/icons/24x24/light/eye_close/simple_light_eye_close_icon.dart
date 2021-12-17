import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightEyeCloseIcon extends StatelessWidget {
  const SimpleLightEyeCloseIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/eye_close/eye_close.svg',
      color: color,
    );
  }
}
