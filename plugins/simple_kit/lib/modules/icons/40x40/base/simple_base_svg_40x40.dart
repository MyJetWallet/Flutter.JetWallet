import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg40X40 extends StatelessWidget {
  const SimpleBaseSvg40X40({
    super.key,
    this.color,
    required this.assetName,
  });

  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 40.0,
        maxHeight: 40.0,
        minWidth: 40.0,
        minHeight: 40.0,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
