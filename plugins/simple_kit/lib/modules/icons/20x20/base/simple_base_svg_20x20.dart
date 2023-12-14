import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg20x20 extends StatelessWidget {
  const SimpleBaseSvg20x20({
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
        maxWidth: 20.0,
        maxHeight: 20.0,
        minWidth: 20.0,
        minHeight: 20.0,
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
