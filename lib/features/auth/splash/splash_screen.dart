import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/splash_screen_gradient.dart';
import 'package:rive/rive.dart';

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
    return const OnboardingScreenGradient(
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
