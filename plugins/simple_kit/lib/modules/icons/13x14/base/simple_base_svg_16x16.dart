import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg13X14 extends StatelessWidget {
  const SimpleBaseSvg13X14({
    super.key,
    required this.assetName,
  });

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 13.0,
        maxHeight: 14.0,
        minWidth: 13.0,
        minHeight: 14.0,
      ),
      child: SvgPicture.asset(
        assetName,
        package: 'simple_kit',
      ),
    );
  }
}
