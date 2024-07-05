import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/base/simple_base_svg_24x24.dart';

class SimpleLightWalletsActiveIcon extends StatelessWidget {
  const SimpleLightWalletsActiveIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/wallets/wallets.svg',
      color: SColorsLight().black,
    );
  }
}

class SimpleLightWalletsDefaultIcon extends StatelessWidget {
  const SimpleLightWalletsDefaultIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg24X24(
      assetName: 'assets/icons/light/24x24/wallets/wallets.svg',
      color: SColorsLight().grey3,
    );
  }
}
