import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/32x32/base/simple_base_svg_32x32.dart';

class SimpleLightMyAssetsActiveIcon extends StatelessWidget {
  const SimpleLightMyAssetsActiveIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg32X32(
      assetName: 'assets/icons/light/32x32/my_assets/my_assets.svg',
      color: SColorsLight().black,
    );
  }
}

class SimpleLightMyAssetsDefaultIcon extends StatelessWidget {
  const SimpleLightMyAssetsDefaultIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg32X32(
      assetName: 'assets/icons/light/32x32/my_assets/my_assets.svg',
      color: SColorsLight().grey3,
    );
  }
}
