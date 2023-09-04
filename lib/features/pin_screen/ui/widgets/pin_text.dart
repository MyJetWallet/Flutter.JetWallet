import 'package:flutter/material.dart';

class PinText extends StatelessWidget {
  const PinText({
    super.key,
    this.fontSize,
    this.color = Colors.black,
    required this.text,
  });

  final double? fontSize;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 14.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
