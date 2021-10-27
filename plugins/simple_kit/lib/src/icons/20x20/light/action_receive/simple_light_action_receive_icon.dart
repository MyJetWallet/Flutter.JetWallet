import 'package:flutter/material.dart';

import '../../base/simple_base_svg_20x20.dart';

class SimpleLightActionReceiveIcon extends StatelessWidget {
  const SimpleLightActionReceiveIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20X20(
      assetName: 'assets/icons/light/20x20/action_receive/action_receive.svg',
      color: color,
    );
  }
}
