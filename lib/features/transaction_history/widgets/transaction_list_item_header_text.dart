import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class TransactionListItemHeaderText extends StatelessWidget {
  const TransactionListItemHeaderText({
    super.key,
    this.textAlign,
    this.color,
    required this.text,
  });

  final String text;
  final TextAlign? textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: STStyles.subtitle1.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
