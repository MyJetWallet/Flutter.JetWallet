import 'package:flutter/material.dart';
import '../../base/simple_base_svg_20x20.dart';

class SimpleLightHideDetailsIcon extends StatelessWidget {
  const SimpleLightHideDetailsIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/simple_card_actions/hide_details.svg',
      color: color,
    );
  }
}
