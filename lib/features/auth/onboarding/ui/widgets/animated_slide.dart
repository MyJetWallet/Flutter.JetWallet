import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import 'slide_container.dart';

class AnimatedOnboardingSlide extends StatelessWidget {
  const AnimatedOnboardingSlide({
    super.key,
    required this.animationController,
    required this.position,
    required this.currentIndex,
  });

  final AnimationController animationController;
  final int position;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final sColors = sKit.colors;

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                SlideContainer(
                  width: 16,
                  color: position < currentIndex ? sColors.black : sColors.black.withOpacity(0.3),
                ),
                if (position == currentIndex)
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return SlideContainer(
                        width: 16 * animationController.value,
                        color: sColors.black,
                      );
                    },
                  )
                else
                  const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
