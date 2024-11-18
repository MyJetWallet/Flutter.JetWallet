import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'onboarding_store.g.dart';

class OnboardingStore extends _OnboardingStoreBase with _$OnboardingStore {
  OnboardingStore() : super();

  static _OnboardingStoreBase of(BuildContext context) => Provider.of<OnboardingStore>(context, listen: false);
}

abstract class _OnboardingStoreBase with Store {
  final _slidesAnimationDuration = const Duration(seconds: 4);

  final _onboardingImages = const [
    onboardingStep1,
    onboardingStep2,
    onboardingStep3,
  ];

  @observable
  ObservableList<String> slidesLabeles = ObservableList.of([]);

  @observable
  ObservableList<String> slidesDescrictions = ObservableList.of([]);

  @observable
  PageController? pageController;

  AnimationController? sliderController;

  @observable
  int currentIndex = 0;
  @action
  int setCurrentIndex(int value) => currentIndex = value;

  @action
  void init(AnimationController controller) {
    sliderController = controller;

    restartAnimation();

    slidesLabeles = ObservableList.of([
      intl.onboarding_title_1,
      intl.onboarding_title_2,
      intl.onboarding_title_3,
    ]);

    slidesDescrictions = ObservableList.of([
      intl.onboarding_descriction_1,
      intl.onboarding_descriction_2,
      intl.onboarding_descriction_3,
    ]);

    sliderController!.addStatusListener(sliderListener);
  }

  void sliderListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (currentIndex + 1 < slidesLabeles.length) {
        currentIndex += 1;
        restartAnimation();
        onSliderChange();
      } else {
        Timer(const Duration(seconds: 5), () {
          startAnimation();
          onSliderChange();
        });
      }
    }
  }

  @action
  void dispose() {
    if (sliderController != null) {
      sliderController!.removeStatusListener(sliderListener);
    }
  }

  @action
  void prevSlider() {
    if (currentIndex - 1 != -1) {
      currentIndex -= 1;
      restartAnimation();
    } else {
      restartAnimation();
    }

    onSliderChange();
  }

  @action
  void startAnimation() {
    currentIndex = 0;
    restartAnimation();
  }

  void restartAnimation() {
    sliderController!.stop();
    sliderController!.reset();
    sliderController!.duration = _slidesAnimationDuration;
    sliderController!.forward();
  }

  void onPanEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      prevSlider();
    } else {
      nextSlider();
    }

    onSliderChange();
  }

  void stopSlider() {
    sliderController!.stop();
  }

  void forwardSlider(LongPressEndDetails detail) {
    sliderController!.forward();

    onSliderChange();
  }

  @action
  void nextSlider() {
    if (currentIndex + 1 < slidesLabeles.length) {
      currentIndex += 1;
      restartAnimation();
    }

    onSliderChange();
  }

  void onSliderChange() {
  //   if (currentIndex == 0) {
  //     sAnalytics.onboardingFinanceIsSimpleScreenView();
  //   }
  }

  String showImages(int index) {
    return _onboardingImages[index];
  }

  void precacheImages(BuildContext context) {
    for (var i = 1; i < _onboardingImages.length; i++) {
      precacheImage(
        Image.asset(_onboardingImages[i]).image,
        context,
      );
    }
  }
}
