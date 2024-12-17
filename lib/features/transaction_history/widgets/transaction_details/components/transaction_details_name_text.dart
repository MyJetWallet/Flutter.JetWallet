import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class TransactionDetailsNameText extends StatelessWidget {
  const TransactionDetailsNameText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Text(
      text,
      style: STStyles.body2Medium.copyWith(
        color: colors.gray10,
      ),
    );
  }
}
