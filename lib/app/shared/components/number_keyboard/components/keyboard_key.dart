import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    required this.keyName,
    required this.onKeyPressed,
  });

  final String keyName;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.2.sw,
      child: InkWell(
        onTap: () => onKeyPressed(keyName),
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.h,
          ),
          child: Center(
            child: Text(
              keyName,
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
