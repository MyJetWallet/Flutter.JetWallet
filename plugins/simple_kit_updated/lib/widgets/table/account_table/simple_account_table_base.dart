import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class SAccountTableBase extends StatelessWidget {
  const SAccountTableBase({
    super.key,
    this.hasButton = false,
    this.isHighlated = false,
    required this.child,
  });

  final bool hasButton;
  final Widget child;

  final bool isHighlated;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isHighlated ? SColorsLight().gray2 : Colors.transparent,
      //height: hasButton ? 128 : 80,
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
