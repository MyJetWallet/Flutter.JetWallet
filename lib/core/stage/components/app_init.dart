import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/screens/navigation/view/navigation.dart';
import '../../../auth/screens/email_verification/view/email_verification.dart';
import '../../../auth/screens/onboarding/onboarding_screen.dart';
import '../../../auth/screens/splash/splash_screen.dart';
import '../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../router/provider/app_init_fpod.dart';
import '../../../router/provider/authorization_stpod/authorization_stpod.dart';
import '../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../shared/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../shared/features/two_fa_phone/view/two_fa_phone.dart';

/// Launches application goes after [RemoteConfigInit]
class AppInit extends HookWidget {
  const AppInit({Key? key}) : super(key: key);

  static const routeName = '/app_init';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(authorizationStpod);
    final appInit = useProvider(appInitFpod);
    final startup = useProvider(startupNotipod);

    return appInit.maybeWhen(
      data: (_) {
        return router.state.when(
          authorized: () {
            //final isAppLoaded = useProvider(initFinishedSpod);

            return startup.authorized.when(
              loading: () => const SplashScreen(),
              emailVerification: () => const EmailVerification(),
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
              home: () => Navigation(),
            );

            /* return isAppLoaded.maybeWhen(
              data: (value) {
                if (value) {
                  return startup.authorized.when(
                    loading: () => const SplashScreen(),
                    emailVerification: () => const EmailVerification(),
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
                    home: () => Navigation(),
                  );
                } else {
                  return const SplashScreen();
                }
              },
              orElse: () => const SplashScreen(),
            );
            */
          },
          unauthorized: () => const OnboardingScreen(),
        );
      },
      orElse: () => const SplashScreen(),
    );
  }
}
