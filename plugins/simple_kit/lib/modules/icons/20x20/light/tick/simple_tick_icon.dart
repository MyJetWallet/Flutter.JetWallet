import 'package:flutter/material.dart';
import '../../base/simple_base_svg_20x20.dart';

class SimpleTickLongIcon extends StatelessWidget {
  const SimpleTickLongIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/tick/tick.svg',
      color: color,
    );
  }
}
