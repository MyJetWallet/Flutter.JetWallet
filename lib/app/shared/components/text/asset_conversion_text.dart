import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetConversionText extends StatelessWidget {
  const AssetConversionText({
    Key? key,
    this.fontSize,
    this.color = Colors.grey,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    required this.text,
  }) : super(key: key);

  final double? fontSize;
  final Color color;
  final FontWeight fontWeight;
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
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class CenterAssetConversionText extends StatelessWidget {
  const CenterAssetConversionText({
    Key? key,
    this.fontSize,
    this.color = Colors.grey,
    this.fontWeight = FontWeight.normal,
    required this.text,
  }) : super(key: key);

  final double? fontSize;
  final Color color;
  final FontWeight fontWeight;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AssetConversionText(
        text: text,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
