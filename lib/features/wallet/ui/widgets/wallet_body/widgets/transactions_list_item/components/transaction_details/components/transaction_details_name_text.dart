import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionDetailsNameText extends StatelessWidget {
  const TransactionDetailsNameText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Text(
      text,
      style: sBodyText2Style.copyWith(
        color: colors.grey1,
      ),
    );
  }
}
