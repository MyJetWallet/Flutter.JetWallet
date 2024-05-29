import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SStepIndicator extends StatelessWidget {
  const SStepIndicator({
    super.key,
    required this.loadedPercent,
  });

  final int loadedPercent;

  @override
  Widget build(BuildContext context) {
    var flex = loadedPercent;
    if (loadedPercent < 0) {
      flex = 0;
    } else if (loadedPercent > 100) {
      flex = 100;
    }

    return Row(
      children: [
        Expanded(
          flex: flex,
          child: Container(
            color: SColorsLight().blue,
            height: 4,
          ),
        ),
        Expanded(
          flex: 100 - flex,
          child: Container(
            color: SColorsLight().white,
            height: 4,
          ),
        ),
      ],
    );
  }
}
