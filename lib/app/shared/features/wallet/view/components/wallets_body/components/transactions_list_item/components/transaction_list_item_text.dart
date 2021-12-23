import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionListItemText extends StatelessWidget {
  const TransactionListItemText({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sBodyText2Style.copyWith(
        color: color,
      ),
    );
  }
}
