import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg40X22 extends StatelessWidget {
  const SimpleBaseSvg40X22({
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
        maxHeight: 22.0,
        minWidth: 40.0,
        minHeight: 22.0,
      ),
      child: SvgPicture.asset(
        assetName,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        package: 'simple_kit',
      ),
    );
  }
}
