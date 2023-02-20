import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/splash_screen_gradient.dart';
import 'package:rive/rive.dart';

class SplashScreenNoAnimation extends StatefulWidget {
  const SplashScreenNoAnimation({super.key});

  @override
  State<SplashScreenNoAnimation> createState() =>
      _SplashScreenNoAnimationState();
}

class _SplashScreenNoAnimationState extends State<SplashScreenNoAnimation> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle', autoplay: false);
  }

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
    return OnboardingFullScreenGradient(
      child: Center(
        child: SizedBox(
          width: 160.0,
          height: 160.0,
          child: RiveAnimation.asset(
            splashAnimationAsset,
            controllers: [_controller],
          ),
        ),
      ),
    );
  }
}
