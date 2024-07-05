import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg16X16 extends StatelessWidget {
  const SimpleBaseSvg16X16({
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
        maxWidth: 16.0,
        maxHeight: 16.0,
        minWidth: 16.0,
        minHeight: 16.0,
      ),
      child: SvgPicture.asset(
        assetName,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        package: 'simple_kit',
      ),
    );
  }
}
