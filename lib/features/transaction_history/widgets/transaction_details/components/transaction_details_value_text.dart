import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TransactionDetailsValueText extends StatelessWidget {
  const TransactionDetailsValueText({
    super.key,
    this.color,
    this.textAlign,
    required this.text,
    this.maxLines = 5,
    this.softWrap,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: STStyles.subtitle2.copyWith(
        color: color,
      ),
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
