import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeaderText extends StatelessWidget {
  const AuthHeaderText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
      ),
    );
  }
}
