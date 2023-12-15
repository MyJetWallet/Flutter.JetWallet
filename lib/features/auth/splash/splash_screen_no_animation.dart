import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';

@RoutePage(name: 'SplashNoAnimationRoute')
class SplashScreenNoAnimation extends StatefulWidget {
  const SplashScreenNoAnimation({super.key});

  @override
  State<SplashScreenNoAnimation> createState() => _SplashScreenNoAnimationState();
}

class _SplashScreenNoAnimationState extends State<SplashScreenNoAnimation> {
  @override
  void initState() {
    super.initState();
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
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          splashSimpleLogoAsset,
          height: 62.53,
        ),
      ),
    );
  }
}
