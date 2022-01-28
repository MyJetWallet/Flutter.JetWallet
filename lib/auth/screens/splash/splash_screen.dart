import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../shared/constants.dart';
import '../../shared/components/gradients/onboarding_full_screen_gradient.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OnboardingFullScreenGradient(
      child: Center(
        child: SizedBox(
          width: 320.0,
          height: 320.0,
          child: RiveAnimation.asset(splashAnimationAsset),
        ),
      ),
    );
  }
}
