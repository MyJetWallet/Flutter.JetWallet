import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/screens/navigation/view/navigation.dart';
import '../../app/shared/features/disclaimer/notifier/disclaimer_notipod.dart';
import '../../auth/screens/email_verification/view/email_verification.dart';
import '../../auth/screens/onboarding/onboarding_screen.dart';
import '../../auth/screens/splash/splash_screen.dart';
import '../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../shared/features/pin_screen/view/pin_screen.dart';
import '../../shared/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../shared/features/two_fa_phone/view/two_fa_phone.dart';
import '../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../shared/providers/service_providers.dart';
import '../provider/router_pod/router_pod.dart';

/// This widget is supposed to be the first one that will
/// be created at the app launch
class AppRouter extends HookWidget {
  const AppRouter({Key? key}) : super(key: key);

  static const routeName = '/router';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerPod);
    useProvider(intlPod.select((_) {}));

    final userInfo = useProvider(userInfoNotipod);

    return router.when(
      loading: () {
        return const SplashScreen();
      },
      emailVerification: () {
        if (userInfo.hasDisclaimers) {
          useProvider(disclaimerNotipod);
        }
        return const EmailVerification();
      },
      twoFaVerification: () {
        if (userInfo.hasDisclaimers) {
          useProvider(disclaimerNotipod);
        }
        return const TwoFaPhone(
          trigger: TwoFaPhoneTriggerUnion.startup(),
        );
      },
      pinSetup: () {
        if (userInfo.hasDisclaimers) {
          useProvider(disclaimerNotipod);
        }
        return const PinScreen(
          union: Setup(),
          cannotLeave: true,
          displayHeader: false,
        );
      },
      pinVerification: () {
        if (userInfo.hasDisclaimers) {
          useProvider(disclaimerNotipod);
        }
        return const PinScreen(
          union: Verification(),
          cannotLeave: true,
          displayHeader: false,
        );
      },
      home: () {
        if (userInfo.hasDisclaimers) {
          useProvider(disclaimerNotipod);
        }
        return Navigation();
      },
      unauthorized: () {
        return const OnboardingScreen();
      },
    );
  }
}
