import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/20x20/base/simple_base_svg_20x20.dart';


class SimpleLightHistoryCompletedIcon extends StatelessWidget {
  const SimpleLightHistoryCompletedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/24x24/history_completed/history_completed.svg',
      color: color,
    );
  }
}
