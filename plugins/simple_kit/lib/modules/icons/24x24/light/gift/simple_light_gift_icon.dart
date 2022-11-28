import 'package:flutter/material.dart';

import '../../base/simple_base_svg_24x24.dart';

class SimpleLightGiftIcon extends StatelessWidget {
  const SimpleLightGiftIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/gift/gift.svg',
      color: color,
    );
  }
}
