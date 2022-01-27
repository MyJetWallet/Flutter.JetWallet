import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/constants.dart';
import '../../../shared/providers/service_providers.dart';
import '../../shared/components/gradients/onboarding_full_screen_gradient.dart';
import '../login/login.dart';
import '../register/register.dart';
import 'components/animated_slide.dart';

const _textAnimationDuration = Duration(seconds: 1);
const _slidesAnimationDuration = Duration(seconds: 4);

const onboardingImages = [
  simpleAppImageAsset,
  buyCryptoImageAsset,
  cryptoIndeciesImageAsset,
  inviteFriendsImageAsset,
];

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
    final colors = useProvider(sColorPod);

    return OnboardingFullScreenGradient(
      backgroundColor: _backgroundColor(_currentIndex, colors),
      onTapNext: _nextSlider,
      onTapBack: _prevSlider,
      onLongPress: _stopSlider,
      onLongPressEnd: _forwardSlider,
      onPanEnd: _onPanEnd,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ListView(
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
                  const SpaceH40(),
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Column(
                      children: [
                        Text(
                          _slides[_currentIndex],
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: sTextH1Style,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(_showImages(_currentIndex)),
                  const SpaceH40(),
                ],
              ),
            ),
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

  void _onPanEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      _prevSlider();
    } else {
      _nextSlider();
    }
  }

  void _stopSlider() {
    _slidesAnimationController.stop();
  }

  void _forwardSlider(LongPressEndDetails detail) {
    _slidesAnimationController.forward();
  }

  void _nextSlider() {
    setState(() {
      if (_currentIndex + 1 < _slides.length) {
        _currentIndex += 1;
        _restartAnimation();
      }
    });
  }

  void _prevSlider() {
    setState(() {
      if (_currentIndex - 1 != -1) {
        _currentIndex -= 1;
        _restartAnimation();
      } else {
        _restartAnimation();
      }
    });
  }

  String _showImages(int index) {
    return onboardingImages[index];
  }

  Color _backgroundColor(int index, SimpleColors colors) {
    if (index == 0) {
      return colors.blueLight2;
    } else if (index == 1) {
      return colors.greenLight2;
    } else if (index == 2) {
      return colors.brownLight;
    } else {
      return colors.violetLight;
    }
  }
}
