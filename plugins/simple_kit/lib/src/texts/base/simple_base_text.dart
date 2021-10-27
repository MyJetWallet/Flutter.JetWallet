import 'package:flutter/material.dart';

class SimpleBaseText extends StatelessWidget {
  const SimpleBaseText({
    Key? key,
    this.color,
    this.maxLines,
    this.textAlign,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
