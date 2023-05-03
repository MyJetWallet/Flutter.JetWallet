import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionDetailsValueText extends StatelessWidget {
  const TransactionDetailsValueText({
    Key? key,
    this.color,
    this.textAlign,
    required this.text,
  }) : super(key: key);

  final String text;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: sSubtitle3Style.copyWith(
        color: color,
      ),
      maxLines: 5,
    );
  }
}
