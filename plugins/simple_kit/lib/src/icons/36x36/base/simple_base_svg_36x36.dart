import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg36X36 extends StatelessWidget {
  const SimpleBaseSvg36X36({
    Key? key,
    required this.assetName,
    required this.color,
  }) : super(key: key);

  final String assetName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 36.w,
        maxHeight: 36.w,
        minWidth: 36.w,
        minHeight: 36.w,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
