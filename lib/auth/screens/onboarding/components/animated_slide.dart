import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import 'slide_container.dart';

class AnimatedOnboardingSlide extends HookWidget {
  const AnimatedOnboardingSlide({
    Key? key,
    required this.animationController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  final AnimationController animationController;
  final int position;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final sColors = useProvider(sColorPod);

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                SlideContainer(
                  width: 24.0,
                  color: position < currentIndex
                      ? sColors.black
                      : sColors.black.withOpacity(0.3),
                ),
                if (position == currentIndex)
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return SlideContainer(
                        width: 24.0 * animationController.value,
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
