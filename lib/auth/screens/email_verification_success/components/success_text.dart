import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessText extends StatelessWidget {
  const SuccessText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Success',
      style: TextStyle(
        fontSize: 39.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
