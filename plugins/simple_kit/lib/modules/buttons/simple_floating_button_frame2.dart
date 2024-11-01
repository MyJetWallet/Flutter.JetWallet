import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';

class SFloatingButtonFrame2 extends StatelessWidget {
  const SFloatingButtonFrame2({
    super.key,
    required this.button,
  });

  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Container(
            height: 27.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.1, 1],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  SColorsLight().white,
                  SColorsLight().white.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: SColorsLight().white,
              child: Column(
                children: [
                  button,
                  const SpaceH20(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
