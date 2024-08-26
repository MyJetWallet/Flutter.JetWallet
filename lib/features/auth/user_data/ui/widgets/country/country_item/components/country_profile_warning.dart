import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class CountryProfileWarning extends StatelessWidget {
  const CountryProfileWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SInfoIcon(
      color: colors.red,
    );
  }
}
