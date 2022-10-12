import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/splash_screen_gradient.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.runAnimation = true});

  final bool runAnimation;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        SimpleAnimation('SplashScreen', autoplay: widget.runAnimation);
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
          width: 320.0,
          height: 320.0,
          child: RiveAnimation.asset(
            splashAnimationAsset,
            controllers: [_controller],
          ),
        ),
      ),
    );
  }
}
