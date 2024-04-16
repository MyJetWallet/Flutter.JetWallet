import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/32x32/base/simple_base_svg_32x32.dart';

class SimpleLightAccountBarActiveIcon extends StatelessWidget {
  const SimpleLightAccountBarActiveIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg32X32(
      assetName: 'assets/icons/light/32x32/account_bar/account_bar.svg',
      color: SColorsLight().black,
    );
  }
}

class SimpleLightAccountBarDefaultIcon extends StatelessWidget {
  const SimpleLightAccountBarDefaultIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg32X32(
      assetName: 'assets/icons/light/32x32/account_bar/account_bar.svg',
      color: SColorsLight().grey3,
    );
  }
}
