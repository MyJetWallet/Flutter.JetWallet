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
      width: 0.2.sw,
      height: 0.08.sh,
      child: child,
    );
  }
}
