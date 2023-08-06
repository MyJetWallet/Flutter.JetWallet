import 'package:flutter/material.dart';
import 'transaction_details_name_text.dart';

class TransactionDetailsItem extends StatelessWidget {
  const TransactionDetailsItem({
    super.key,
    this.fromStart = false,
    required this.text,
    required this.value,
  });

  final String text;
  final Widget value;
  final bool fromStart;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: fromStart
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center,
      children: [
        TransactionDetailsNameText(
          text: text,
        ),
        const Spacer(),
        value,
      ],
    );
  }
}
