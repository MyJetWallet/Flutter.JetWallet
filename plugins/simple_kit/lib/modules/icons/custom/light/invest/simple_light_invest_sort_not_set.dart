import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/custom/base/simple_custom_svg.dart';

class SimpleLightInvestSortNotSetIcon extends StatelessWidget {
  const SimpleLightInvestSortNotSetIcon({
    super.key,
    this.color,
    this.width,
    this.height,
  });

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SimpleCustomSvg(
      assetName: 'assets/icons/light/custom/invest/sort_not_set.svg',
      color: color,
      width: width,
      height: height,
    );
  }
}
