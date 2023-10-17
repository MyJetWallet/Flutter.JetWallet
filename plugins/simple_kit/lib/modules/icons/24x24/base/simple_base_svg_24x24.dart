import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg24X24 extends StatelessWidget {
  const SimpleBaseSvg24X24({
    Key? key,
    this.color,
    required this.assetName,
  }) : super(key: key);

  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 24.0,
        maxHeight: 24.0,
        minWidth: 24.0,
        minHeight: 24.0,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
