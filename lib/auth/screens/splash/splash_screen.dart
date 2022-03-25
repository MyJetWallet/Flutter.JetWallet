import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../shared/constants.dart';
import '../../shared/components/gradients/onboarding_full_screen_gradient.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
      Image.asset(simpleAppImageAsset).image,
      context,
    );
  }

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
