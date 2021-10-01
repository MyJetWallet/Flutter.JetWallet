import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/screens/navigation/view/navigation.dart';
import '../../../auth/screens/email_verification/view/email_verification.dart';
import '../../../auth/screens/welcome/view/welcome.dart';
import '../../../shared/components/app_frame.dart';
import '../../../shared/components/loader.dart';
import '../../../shared/features/phone_verification/model/phone_verification_trigger_union.dart';
import '../../../shared/features/phone_verification/phone_verification_enter/view/phone_verification_enter.dart';
import '../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../shared/features/two_fa/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../shared/features/two_fa/two_fa_phone/view/two_fa_phone.dart';
import '../../notifier/startup_notifier/startup_notipod.dart';
import '../../provider/app_init_fpod.dart';
import '../../provider/router_stpod/router_stpod.dart';
import '../../provider/signalr_init_fpod.dart';

/// Launches application goes after [RemoteConfigInit]
class AppInit extends HookWidget {
  const AppInit({Key? key}) : super(key: key);

  static const routeName = 'app_init';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerStpod);
    final appInit = useProvider(appInitFpod);
    final startup = useProvider(startupNotipod);
    final signalRInit = useProvider(signalRInitFpod);

    return AppFrame(
      child: appInit.when(
        data: (_) {
          return router.state.when(
            authorized: () {
              return startup.authorized.when(
                loading: () => const Loader(
                  color: Colors.lime,
                ),
                emailVerification: () => const EmailVerification(),
                phoneVerification: () {
                  return const PhoneVerificationEnter(
                    trigger: PhoneVerificationTriggerUnion.startup(),
                  );
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
                  return signalRInit.when(
                    data: (_) => Navigation(),
                    loading: () => const Loader(
                      color: Colors.green,
                    ),
                    error: (e, st) => Text('$e'),
                  );
                },
              );
            },
            unauthorized: () => Welcome(),
          );
        },
        loading: () => const Loader(
          color: Colors.red,
        ),
        error: (e, st) => Text('$e'),
      ),
    );
  }
}
