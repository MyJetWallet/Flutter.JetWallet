import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/custom/base/simple_custom_svg.dart';

class SimpleLightInvestChartCandlesIcon extends StatelessWidget {
  const SimpleLightInvestChartCandlesIcon({
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
      assetName: 'assets/icons/light/custom/invest/chart_candles.svg',
      color: color,
      width: width,
      height: height,
    );
  }
}
