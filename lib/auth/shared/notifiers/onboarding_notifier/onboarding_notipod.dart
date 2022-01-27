import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'onboarding_notifier.dart';

final onboardingNotipod =
StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
      (ref) {
    return OnboardingNotifier();
  },
);
