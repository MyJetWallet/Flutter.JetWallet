import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base/simple_base_text.dart';

class STextH1 extends StatelessWidget {
  const STextH1({
    Key? key,
    this.color,
    this.textAlign,
    this.maxLines,
    required this.text,
  }) : super(key: key);

  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseText(
      text: text,
      color: color,
      fontSize: 40.sp,
      maxLines: maxLines,
      fontWeight: FontWeight.w600,
      textAlign: textAlign,
    );
  }
}
