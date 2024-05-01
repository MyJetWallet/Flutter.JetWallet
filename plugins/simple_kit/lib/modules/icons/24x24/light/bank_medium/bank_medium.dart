import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/20x20/base/simple_base_svg_20x20.dart';

class SimpleLightBankMediumIcon extends StatelessWidget {
  const SimpleLightBankMediumIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20x20(
      assetName: 'assets/icons/light/24x24/bank_medium/bank_medium.svg',
      color: color,
    );
  }
}
