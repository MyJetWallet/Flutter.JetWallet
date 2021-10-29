import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/navigator_push.dart';
import '../../shared/components/gradients/onboarding_full_screen_gradient.dart';
import '../login/login.dart';
import '../register/register.dart';
import 'components/animated_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen>
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
  int _currentIndex = 0;
  bool _reverse = false;
  static const _textAnimationDuration = Duration(seconds: 1);
  static const _slidesAnimationDuration = Duration(seconds: 2);
  static const List<String> _slides = [
    'Welcome\nto Simple',
    'Buy and Sell\ncrypto in 2 clicks',
    'Send crypto\nto anyone',
    'All wallets \nin one place',
  ];

  @override
  void initState() {
    super.initState();
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
    return OnboardingFullScreenGradient(
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
                      AnimatedOnboardingSlide(
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
              child: Text(
                _slides[_currentIndex],
                maxLines: 2,
                textAlign: TextAlign.center,
                style: sTextH1Style,
              ),
            ),
            const Spacer(),
            SPrimaryButton1(
              active: true,
              name: 'Get Started',
              onTap: () => navigatorPush(context, const Register()),
            ),
            const SpaceH10(),
            STextButton1(
              active: true,
              name: 'Sign in',
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
