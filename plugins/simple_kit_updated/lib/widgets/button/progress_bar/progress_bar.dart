import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return LinearProgressIndicator(
      value: value,
      backgroundColor: colors.gray4,
      color: value < 0.7 ? colors.blue : colors.red,
      borderRadius: BorderRadius.circular(1.50),
    );
  }
}
