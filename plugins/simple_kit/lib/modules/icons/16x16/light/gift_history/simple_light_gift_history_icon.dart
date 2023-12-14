import 'package:flutter/material.dart';

import '../../base/simple_base_svg_16x16.dart';

class SimpleLightGiftHistoryIcon extends StatelessWidget {
  const SimpleLightGiftHistoryIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg16X16(
      assetName: 'assets/icons/light/16x16/gift_history/gift_history.svg',
      color: color,
    );
  }
}
