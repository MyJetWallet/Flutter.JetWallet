import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/screens/navigation/view/navigation.dart';
import '../../auth/screens/email_verification/view/email_verification.dart';
import '../../auth/screens/onboarding/onboarding_screen.dart';
import '../../auth/screens/splash/splash_screen.dart';
import '../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../shared/features/pin_screen/view/pin_screen.dart';
import '../../shared/features/two_fa/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../shared/features/two_fa/two_fa_phone/view/two_fa_phone.dart';
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

    return router.when(
      loading: () {
        return const SplashScreen();
      },
      emailVerification: () {
        return const EmailVerification();
      },
      twoFaVerification: () {
        return const TwoFaPhone(
          trigger: TwoFaPhoneTriggerUnion.startup(),
        );
      },
      pinSetup: () {
        return const PinScreen(
          union: Setup(),
          cannotLeave: true,
        );
      },
      pinVerification: () {
        return const PinScreen(
          union: Verification(),
          cannotLeave: true,
        );
      },
      home: () {
        return Navigation();
      },
      unauthorized: () {
        return const OnboardingScreen();
      },
    );
  }
}
