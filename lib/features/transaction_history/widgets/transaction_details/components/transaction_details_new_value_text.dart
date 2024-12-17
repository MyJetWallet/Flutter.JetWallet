import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class TransactionDetailsNewValueText extends StatelessWidget {
  const TransactionDetailsNewValueText({
    super.key,
    this.color,
    this.textAlign,
    this.maxLines = 5,
    required this.text,
  });

  final String text;
  final int maxLines;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: STStyles.subtitle1.copyWith(
        color: color,
      ),
      maxLines: maxLines,
    );
  }
}
