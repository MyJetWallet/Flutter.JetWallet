import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/shared/components/loaders/loader.dart';

import '../../../app/screens/navigation/view/navigation.dart';
import '../../../auth/screens/email_verification/view/email_verification.dart';
import '../../../auth/screens/onboarding/onboarding_screen.dart';
import '../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../shared/features/two_fa/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../shared/features/two_fa/two_fa_phone/view/two_fa_phone.dart';
import '../../notifier/startup_notifier/startup_notipod.dart';
import '../../provider/app_init_fpod.dart';
import '../../provider/router_stpod/router_stpod.dart';

/// Launches application goes after [RemoteConfigInit]
class AppInit extends HookWidget {
  const AppInit({Key? key}) : super(key: key);

  static const routeName = 'app_init';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerStpod);
    final appInit = useProvider(appInitFpod);
    final startup = useProvider(startupNotipod);

    return appInit.when(
      data: (_) {
        return router.state.when(
          authorized: () {
            return startup.authorized.when(
              loading: () => const Loader(
                color: Colors.white,
              ),
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
          },
          unauthorized: () => const OnboardingScreen(),
        );
      },
      loading: () => const Loader(
        color: Colors.white,
      ),
      error: (e, st) => Text('$e'),
    );
  }
}
