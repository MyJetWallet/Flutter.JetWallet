import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleHideBalanceDots extends StatelessWidget {
  const SimpleHideBalanceDots({
    Key? key,
    this.margin = const EdgeInsets.symmetric(horizontal: 1.0),
    this.baseCurrPrefix = '',
    required this.color,
  }) : super(key: key);

  final Color color;
  final EdgeInsetsGeometry margin;
  final String baseCurrPrefix;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$baseCurrPrefix******',
          style: sSubtitle2Style,
        ),
      ],
    );
  }
}
