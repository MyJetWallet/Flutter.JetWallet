import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg extends StatelessWidget {
  const SimpleBaseSvg({
    Key? key,
    required this.assetName,
    required this.color,
  }) : super(key: key);

  final String assetName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      color: color,
      package: 'simple_kit',
    );
  }
}
