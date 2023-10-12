import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightChevronDownDoubleIcon extends StatelessWidget {
  const SimpleLightChevronDownDoubleIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/chevron_down_double/chevron_down_double.svg',
      color: color,
    );
  }
}
