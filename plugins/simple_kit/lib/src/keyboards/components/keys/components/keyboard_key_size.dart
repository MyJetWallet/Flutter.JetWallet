import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyboardKeySize extends StatelessWidget {
  const KeyboardKeySize({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102.w,
      height: 56.h,
      child: child,
    );
  }
}
