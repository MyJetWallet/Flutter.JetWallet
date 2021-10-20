import 'package:flutter/material.dart';

import '../../base/simple_base_svg.dart';

class SLightMailIcon extends StatelessWidget {
  const SLightMailIcon({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg(
      assetName: 'assets/icons/light/mail/mail.svg',
      color: color,
    );
  }
}
