import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    this.realKey,
    required this.frontKey,
    required this.onKeyPressed,
  });

  /// The key that will be returned as the value
  final String? realKey;

  /// The key that will be showed to the user
  /// if realKey isn't provided will be used also as an realKey
  final String frontKey;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.2.sw,
      child: InkWell(
        onTap: () => onKeyPressed(realKey ?? frontKey),
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.h,
          ),
          child: Center(
            child: Text(
              frontKey,
              style: TextStyle(
                fontSize: 36.sp,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
