import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/components/gradients/onboarding_full_screen_gradient.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingFullScreenGradient(
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          width: 120.r,
          height: 120.r,
        ),
      ),
    );
  }
}
