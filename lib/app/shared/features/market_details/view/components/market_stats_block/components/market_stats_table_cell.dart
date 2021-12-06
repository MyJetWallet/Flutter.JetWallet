import 'package:flutter/material.dart';

class MarketStatsTableCell extends StatelessWidget {
  const MarketStatsTableCell({
    Key? key,
    required this.padding,
    required this.child,
  }) : super(key: key);

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: child,
    );
  }
}
