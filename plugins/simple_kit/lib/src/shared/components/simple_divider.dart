import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SDivider extends StatelessWidget {
  const SDivider({
    Key? key,
    this.width,
    this.color,
  }) : super(key: key);

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.h,
      color: color ?? SColorsLight().grey4,
    );
  }
}
