import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SVerifyIndicator extends StatelessWidget {
  const SVerifyIndicator({
    Key? key,
    required this.indicator,
    required this.indicatorToComplete,
  }) : super(key: key);

  final int indicator;
  final int indicatorToComplete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            width: double.infinity,
            height: 12.0,
            decoration: BoxDecoration(
              color: SColorsLight().blueLight,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: calculateWidth(),
          child: Container(
            decoration: BoxDecoration(
              color: SColorsLight().blue,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                bottomLeft: const Radius.circular(16.0),
                topRight: calculateWidth() == 1
                    ? const Radius.circular(16.0)
                    : Radius.zero,
                bottomRight: calculateWidth() == 1
                    ? const Radius.circular(16.0)
                    : Radius.zero,
              ),
            ),
            height: 12,
          ),
        ),
      ],
    );
  }

  double calculateWidth() {
    if (indicator == 0) {
      return 0.0;
    }
    final num = indicator / indicatorToComplete;
    
    return num;
  }
}
