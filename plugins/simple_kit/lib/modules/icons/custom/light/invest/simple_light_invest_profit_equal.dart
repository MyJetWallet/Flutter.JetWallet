import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/custom/base/simple_custom_svg.dart';

class SimpleLightInvestProfitEqualIcon extends StatelessWidget {
  const SimpleLightInvestProfitEqualIcon({
    Key? key,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SimpleCustomSvg(
      assetName: 'assets/icons/light/custom/invest/profit_equal.svg',
      color: color,
      width: width,
      height: height,
    );
  }
}
