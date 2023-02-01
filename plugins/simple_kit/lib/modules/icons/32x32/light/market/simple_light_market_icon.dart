import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/32x32/base/simple_base_svg_32x32.dart';

class SimpleLightMarketActiveIcon extends StatelessWidget {
  const SimpleLightMarketActiveIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg32X32(
      assetName: 'assets/icons/light/32x32/market/market.svg',
      color: SColorsLight().black,
    );
  }
}

class SimpleLightMarketDefaultIcon extends StatelessWidget {
  const SimpleLightMarketDefaultIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg32X32(
      assetName: 'assets/icons/light/32x32/market/market.svg',
      color: SColorsLight().grey3,
    );
  }
}
