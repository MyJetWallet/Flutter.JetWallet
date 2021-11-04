import 'package:flutter/material.dart';

import '../../base/simple_base_svg_r24x24.dart';

class SimpleLightCheckboxSelectedIcon extends StatelessWidget {
  const SimpleLightCheckboxSelectedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgR24X24(
      assetName: 'assets/icons/light/24x24/checkbox/checkbox_selected.svg',
      color: color,
    );
  }
}
