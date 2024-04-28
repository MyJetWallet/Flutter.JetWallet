import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class SDivider extends StatelessWidget {
  const SDivider({
    super.key,
    this.width,
    this.height,
    this.color,
  });

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      indent: 0,
      thickness: height ?? 1.0,
      color: color ?? SColorsLight().gray4,
    );
  }
}
