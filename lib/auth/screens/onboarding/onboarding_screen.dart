import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/providers/service_providers.dart';
import '../../shared/components/gradients/onboarding_full_screen_gradient.dart';
import '../login/login.dart';
import '../register/register.dart';
import 'components/animated_slide.dart';

const _textAnimationDuration = Duration(seconds: 1);
const _slidesAnimationDuration = Duration(seconds: 2);

class OnboardingScreen extends StatefulHookWidget {
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

  late List<String> _slides;

  @override
  void initState() {
    super.initState();
    _restartTextAnimation();
    _restartAnimation();

    final intl = context.read(intlPod);

    _slides = [
      intl.onboarding_slide1,
      intl.onboarding_slide2,
      intl.onboarding_slide3,
      intl.onboarding_slide4,
    ];

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
    final intl = useProvider(intlPod);

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
              name: intl.onboarding_getStarted,
              onTap: () => Register.push(context),
            ),
            const SpaceH10(),
            STextButton1(
              active: true,
              name: intl.onboarding_signIn,
              onTap: () => Login.push(context),
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
