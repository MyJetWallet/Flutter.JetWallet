import 'package:flutter/material.dart';

class SimpleBaseText extends StatelessWidget {
  const SimpleBaseText({
    Key? key,
    this.color,
    this.maxLines,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final Color? color;
  final int? maxLines;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
