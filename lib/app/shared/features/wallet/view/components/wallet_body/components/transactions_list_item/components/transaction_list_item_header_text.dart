import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionListItemHeaderText extends StatelessWidget {
  const TransactionListItemHeaderText({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: sSubtitle2Style,
      ),
    );
  }
}
