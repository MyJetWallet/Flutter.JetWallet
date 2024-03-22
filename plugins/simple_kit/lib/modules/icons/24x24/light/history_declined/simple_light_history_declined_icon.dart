import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/20x20/base/simple_base_svg_20x20.dart';

class SimpleLightHistoryDeclinedIcon extends StatelessWidget {
  const SimpleLightHistoryDeclinedIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName:
          'assets/icons/light/24x24/history_declined/history_declined.svg',
      color: color,
    );
  }
}
