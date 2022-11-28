import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

part 'onboarding_store.g.dart';

class OnboardingStore extends _OnboardingStoreBase with _$OnboardingStore {
  OnboardingStore() : super();

  static _OnboardingStoreBase of(BuildContext context) =>
      Provider.of<OnboardingStore>(context, listen: false);
}

abstract class _OnboardingStoreBase with Store {
  final _slidesAnimationDuration = const Duration(seconds: 4);
  final _onboardingImages = const [
    simpleAppImageAsset,
    buyCryptoImageAsset,
    cryptoIndeciesImageAsset,
    inviteFriendsImageAsset,
  ];

  @observable
  PageController? pageController;

  @observable
  AnimationController? sliderController;

  @observable
  int currentIndex = 0;
  @action
  int setCurrentIndex(int value) => currentIndex = value;

  @observable
  ObservableList<String> slides = ObservableList.of([]);

  @action
  void init(AnimationController controller) {
    sliderController = controller;

    restartAnimation();

    slides = ObservableList.of([
      intl.onboarding_simpleApp,
      intl.onboarding_buy_crypto,
      intl.onboarding_free_worldwide_transfers,
      intl.onboarding_exchange_any_crypto,
    ]);

    sliderController!.addStatusListener(sliderListener);
  }

  void sliderListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (currentIndex + 1 < slides.length) {
        currentIndex += 1;
        restartAnimation();
      } else {
        Timer(const Duration(seconds: 5), () {
          startAnimation();
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
  }

  void stopSlider() {
    sliderController!.stop();
  }

  void forwardSlider(LongPressEndDetails detail) {
    sliderController!.forward();
  }

  @action
  void nextSlider() {
    if (currentIndex + 1 < slides.length) {
      currentIndex += 1;
      restartAnimation();
    }
  }

  String showImages(int index) {
    return _onboardingImages[index];
  }

  Color backgroundColor(SimpleColors colors) {
    if (currentIndex == 0) {
      return colors.blueLight2;
    } else if (currentIndex == 1) {
      return colors.greenLight2;
    } else if (currentIndex == 2) {
      return colors.brownLight;
    } else {
      return colors.violetLight;
    }
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
