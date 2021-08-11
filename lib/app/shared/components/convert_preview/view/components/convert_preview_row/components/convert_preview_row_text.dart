import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConvertPreviewRowText extends StatelessWidget {
  const ConvertPreviewRowText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
