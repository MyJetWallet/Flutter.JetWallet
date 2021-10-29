import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg36X36 extends StatelessWidget {
  const SimpleBaseSvg36X36({
    Key? key,
    this.color,
    required this.assetName,
  }) : super(key: key);

  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 36.r,
        maxHeight: 36.r,
        minWidth: 36.r,
        minHeight: 36.r,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
