import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:simple_kit/simple_kit.dart';

class CountryProfileWarning extends StatelessWidget {
  const CountryProfileWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SInfoIcon(
      color: colors.red,
    );
  }
}
