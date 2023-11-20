import 'package:flutter/material.dart';
import '../../base/simple_base_svg_20x20.dart';

class SimpleLightTerminateIcon extends StatelessWidget {
  const SimpleLightTerminateIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/20x20/simple_card_actions/terminate.svg',
      color: color,
    );
  }
}
