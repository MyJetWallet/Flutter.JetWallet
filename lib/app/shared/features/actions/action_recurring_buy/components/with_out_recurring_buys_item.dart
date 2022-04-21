import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class WithOutRecurringBuysItem extends StatelessWidget {
  const WithOutRecurringBuysItem({
    Key? key,
    required this.primaryText,
    required this.onTap,
  }) : super(key: key);

  final String primaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 64,
        child: Text(
          primaryText,
          style: sSubtitle2Style,
        ),
      ),
    );
  }
}
