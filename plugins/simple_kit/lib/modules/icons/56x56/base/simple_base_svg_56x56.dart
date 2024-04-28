import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg56X56 extends StatelessWidget {
  const SimpleBaseSvg56X56({
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
        maxWidth: 56.0,
        maxHeight: 56.0,
        minWidth: 56.0,
        minHeight: 56.0,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        height: 56.0,
        width: 56.0,
        package: 'simple_kit',
      ),
    );
  }
}
