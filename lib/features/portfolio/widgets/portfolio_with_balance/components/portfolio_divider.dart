import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class PortfolioDivider extends StatelessWidget {
  const PortfolioDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: SDivider(
        color: colors.grey3,
      ),
    );
  }
}
