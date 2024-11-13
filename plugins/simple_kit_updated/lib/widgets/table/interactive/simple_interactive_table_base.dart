import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class SAccountTableBase extends StatelessWidget {
  const SAccountTableBase({
    super.key,
    this.isHighlighted = false,
    required this.child,
  });

  final Widget child;

  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isHighlighted ? SColorsLight().gray2 : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: child,
      ),
    );
  }
}
