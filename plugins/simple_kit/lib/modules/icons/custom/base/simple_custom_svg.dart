import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleCustomSvg extends StatelessWidget {
  const SimpleCustomSvg({
    super.key,
    this.color,
    this.width,
    this.height,
    required this.assetName,
  });

  final double? width;
  final double? height;
  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width ?? 40.0,
        maxHeight: height ?? 25.0,
        minWidth: width ?? 40.0,
        minHeight: height ?? 25.0,
      ),
      child: SvgPicture.asset(
        assetName,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        package: 'simple_kit',
      ),
    );
  }
}
