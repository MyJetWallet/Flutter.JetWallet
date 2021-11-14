import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SimpleAccountProtectionIndicator extends StatelessWidget {
  const SimpleAccountProtectionIndicator({
    Key? key,
    required this.indicatorColor,
  }) : super(key: key);

  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            width: double.infinity,
            height: 12.h,
            decoration: BoxDecoration(
              color: SColorsLight().grey6,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: (indicatorColor == Colors.red)
                ? 109.w
                : (indicatorColor == Colors.yellow)
                ? 218.w
                : double.infinity,
            height: 12.h,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                topRight: (indicatorColor == Colors.green)
                    ? Radius.circular(16.r)
                    : Radius.zero,
                bottomRight: (indicatorColor == Colors.green)
                    ? Radius.circular(16.r)
                    : Radius.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
