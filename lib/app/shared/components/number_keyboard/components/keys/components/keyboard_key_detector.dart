import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyboardKeyDetector extends StatelessWidget {
  const KeyboardKeyDetector({
    Key? key,
    this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget? child;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
        ),
        child: child,
      ),
    );
  }
}
