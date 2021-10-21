import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg20X20 extends StatelessWidget {
  const SimpleBaseSvg20X20({
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
        maxWidth: 20.w,
        maxHeight: 20.w,
        minWidth: 20.w,
        minHeight: 20.w,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
