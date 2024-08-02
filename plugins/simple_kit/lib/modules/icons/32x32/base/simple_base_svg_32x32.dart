import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg32X32 extends StatelessWidget {
  const SimpleBaseSvg32X32({
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
        maxWidth: 32.0,
        maxHeight: 32.0,
        minWidth: 32.0,
        minHeight: 32.0,
      ),
      child: SvgPicture.asset(
        assetName,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        package: 'simple_kit',
      ),
    );
  }
}
