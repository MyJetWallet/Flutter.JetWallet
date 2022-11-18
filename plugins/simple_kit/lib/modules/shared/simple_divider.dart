import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SDivider extends StatelessWidget {
  const SDivider({
    Key? key,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 1.0,
      color: color ?? SColorsLight().grey4,
    );
  }
}
