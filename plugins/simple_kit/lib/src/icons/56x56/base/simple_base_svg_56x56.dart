import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleBaseSvg56X56 extends StatelessWidget {
  const SimpleBaseSvg56X56({
    Key? key,
    this.color,
    required this.assetName,
  }) : super(key: key);

  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      /// Here we need explicitly to specify width and height
      /// because these icons are used in the NavigationBar and if we 
      /// use only .r, which is perfect square, then we can't fill the
      /// whole NavigationBar in width
      constraints: BoxConstraints(
        maxWidth: 56.w,
        maxHeight: 56.h,
        minWidth: 56.w,
        minHeight: 56.h,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
