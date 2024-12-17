import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class TransactionListItemText extends StatelessWidget {
  const TransactionListItemText({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: STStyles.body2Medium.copyWith(
        color: color,
      ),
    );
  }
}
