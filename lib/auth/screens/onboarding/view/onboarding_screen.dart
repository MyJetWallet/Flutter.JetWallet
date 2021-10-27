import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/gradients/on_boarding_full_screen_gradient.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../login/login.dart';
import '../../register/register.dart';
import '../../splash/provider/strings_pod.dart';
import 'components/animated_slide.dart';

class OnBoardingScreen extends StatefulHookWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _textAnimationController = AnimationController(
    vsync: this,
  );
  late final Animation<double> _textAnimation = CurvedAnimation(
    parent: _textAnimationController,
    curve: Curves.easeIn,
  );
  late final AnimationController _slidesAnimationController =
      AnimationController(
    vsync: this,
  );
  late final List<String> _slides;
  int _currentIndex = 0;
  bool _reverse = false;
  static const _textAnimationDuration = Duration(seconds: 1);
  static const _slidesAnimationDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    final strings = context.read(stringsPod);
    _slides = [
      strings.onBoardingWelcomeToSimple,
      strings.onBoardingBuyAndSellCryptoIn2Clicks,
      strings.onBoardingSendCryptoToAnyone,
      strings.onBoardingAllWalletsInOnePlace,
    ];

    _restartTextAnimation();
    _restartAnimation();

    _textAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (_currentIndex < _slides.length) {
          setState(() {
            _reverse = !_reverse;
            _restartTextAnimation();
          });
        }
      }
    });
    _slidesAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_currentIndex + 1 < _slides.length) {
            _currentIndex += 1;
            _restartAnimation();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = useProvider(stringsPod);

    return OnBoardingFullScreenGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SpaceH75(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _slides
                  .asMap()
                  .map((i, e) {
                    return MapEntry(
                      i,
                      AnimatedOnBoardingSlide(
                        position: i,
                        currentIndex: _currentIndex,
                        animationController: _slidesAnimationController,
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
            const SpaceH62(),
            FadeTransition(
              opacity: _textAnimation,
              child: STextH1(
                text: _slides[_currentIndex],
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            SPrimaryButton1(
              active: true,
              name: strings.onBoardingGetStarted,
              onTap: () => navigatorPush(context, const Register()),
            ),
            const SpaceH10(),
            STextButton1(
              active: true,
              name: strings.onBoardingSignIn,
              onTap: () => navigatorPush(context, const Login()),
            ),
            const SpaceH40(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _slidesAnimationController.dispose();
    super.dispose();
  }

  void _restartAnimation() {
    _slidesAnimationController.stop();
    _slidesAnimationController.reset();
    _slidesAnimationController.duration = _slidesAnimationDuration;
    _slidesAnimationController.forward();
  }

  void _restartTextAnimation() {
    if (_reverse) {
      if (_currentIndex + 1 != _slides.length) {
        _textAnimationController.reverse();
      }
    } else {
      _textAnimationController.stop();
      _textAnimationController.reset();
      _textAnimationController.duration = _textAnimationDuration;
      _textAnimationController.forward();
    }
  }
}
