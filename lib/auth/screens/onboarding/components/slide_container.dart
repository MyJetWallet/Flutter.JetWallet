import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlideContainer extends StatelessWidget {
  const SlideContainer({
    Key? key,
    required this.color,
    required this.width,
  }) : super(key: key);

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.h,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
