import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleCustomSvg extends StatelessWidget {
  const SimpleCustomSvg({
    Key? key,
    this.color,
    this.width,
    this.height,
    required this.assetName,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    print(width);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width ?? 40.0,
        maxHeight: height ?? 25.0,
        minWidth: width ?? 40.0,
        minHeight: height ?? 25.0,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
