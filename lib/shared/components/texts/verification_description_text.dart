import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationDescriptionText extends HookWidget {
  const VerificationDescriptionText({
    Key? key,
    required this.text,
    required this.boldText,
  }) : super(key: key);

  final String text;
  final String boldText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: text,
          ),
          TextSpan(
            text: boldText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
