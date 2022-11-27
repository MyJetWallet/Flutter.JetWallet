import 'package:flutter/material.dart';
import 'transaction_details_name_text.dart';

class TransactionDetailsItem extends StatelessWidget {
  const TransactionDetailsItem({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

  final String text;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
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
