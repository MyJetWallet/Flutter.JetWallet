import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/custom/base/simple_custom_svg.dart';

class SimpleLightStarsIcon extends StatelessWidget {
  const SimpleLightStarsIcon({
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
      assetName: 'assets/icons/light/custom/stars/stars.svg',
      color: color,
      width: width,
      height: height,
    );
  }
}
