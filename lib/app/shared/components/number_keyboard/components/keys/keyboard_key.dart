import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/keyboard_key_detector.dart';
import 'components/keyboard_key_size.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    required this.realValue,
    required this.frontKey,
    required this.onKeyPressed,
  });

  /// The value that will be returned onPressed
  final String realValue;

  /// The key that will be showed to the user
  final String frontKey;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return KeyboardKeySize(
      child: KeyboardKeyDetector(
        onTap: () => onKeyPressed(realValue),
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
    );
  }
}
