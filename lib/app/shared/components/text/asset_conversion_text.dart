import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetConversionText extends StatelessWidget {
  const AssetConversionText({
    Key? key,
    this.fontSize,
    this.textAlign = TextAlign.start,
    required this.text,
  }) : super(key: key);

  final double? fontSize;
  final TextAlign textAlign;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize ?? 12.sp,
        color: Colors.grey,
      ),
    );
  }
}
