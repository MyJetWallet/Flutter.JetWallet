import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

import '../../../shared/constants.dart';
import '../../shared/components/gradients/onboarding_full_screen_gradient.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingFullScreenGradient(
      child: Center(
        child: SizedBox(
          width: 320.r,
          height: 320.r,
          child: const RiveAnimation.asset(splashAnimationAsset),
        ),
      ),
    );
  }
}
