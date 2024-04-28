import 'package:flutter/material.dart';
import '../../base/simple_base_svg_20x20.dart';

class SimpleLightCheckListIcon extends StatelessWidget {
  const SimpleLightCheckListIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/list_checkmark/check_list.svg',
      color: color,
    );
  }
}
