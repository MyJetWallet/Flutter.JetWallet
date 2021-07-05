import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailIsConfirmedText extends StatelessWidget {
  const EmailIsConfirmedText({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Your email address $email is confirmed',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
