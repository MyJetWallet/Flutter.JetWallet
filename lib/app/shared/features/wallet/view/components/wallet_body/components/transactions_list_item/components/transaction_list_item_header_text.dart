import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionListItemHeaderText extends StatelessWidget {
  const TransactionListItemHeaderText({
    Key? key,
    this.textAlign,
    required this.text,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sSubtitle2Style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
