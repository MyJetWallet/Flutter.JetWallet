import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SimpleAccountProtectionIndicator extends StatelessWidget {
  const SimpleAccountProtectionIndicator({
    super.key,
    required this.indicatorColor,
  });

  final Color indicatorColor;

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
        Positioned(
          child: Container(
            width: (indicatorColor == Colors.red)
                ? 109.0
                : (indicatorColor == Colors.yellow)
                    ? 218.0
                    : double.infinity,
            height: 12.0,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                bottomLeft: const Radius.circular(16.0),
                topRight: (indicatorColor == Colors.green)
                    ? const Radius.circular(16.0)
                    : Radius.zero,
                bottomRight: (indicatorColor == Colors.green)
                    ? const Radius.circular(16.0)
                    : Radius.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
