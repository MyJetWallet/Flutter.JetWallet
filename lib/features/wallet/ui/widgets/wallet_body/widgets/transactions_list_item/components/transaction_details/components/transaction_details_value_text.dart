import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionDetailsValueText extends StatelessWidget {
  const TransactionDetailsValueText({
    super.key,
    this.color,
    this.textAlign,
    required this.text,
    this.maxLines = 5,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: sSubtitle3Style.copyWith(
        color: color,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
