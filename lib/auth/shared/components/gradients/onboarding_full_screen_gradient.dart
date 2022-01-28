import 'package:flutter/material.dart';

import '../styles/gradient_colors.dart';

class OnboardingFullScreenGradient extends StatelessWidget {
  const OnboardingFullScreenGradient({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: onBoardingGradientColors,
        ),
      ),
      child: child,
    );
  }
}
