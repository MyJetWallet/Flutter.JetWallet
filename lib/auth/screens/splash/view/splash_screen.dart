import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/screens/navigation/view/navigation.dart';
import '../../../../shared/components/gradients/on_boarding_full_screen_gradient.dart';
import '../../../../shared/components/loaders/loader.dart';
import '../../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../../shared/features/two_fa/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../../shared/features/two_fa/two_fa_phone/view/two_fa_phone.dart';
import '../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../email_verification/view/email_verification.dart';
import '../../onboarding/view/onboarding_screen.dart';
import '../notifier/remote_config_notifier/remote_config_notipod.dart';
import '../notifier/startup_notifier/startup_notipod.dart';
import '../provider/app_init_fpod.dart';
import '../provider/router_stpod/router_stpod.dart';
import '../provider/signalr_init_fpod.dart';
import '../provider/strings_pod.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    useProvider(intlPod.select((_) {}));
    useProvider(stringsPod.select((_) {}));
    final remoteConfig = context.read(remoteConfigNotipod);
    final router = context.read(routerStpod);
    final appInit = context.read(appInitFpod);
    final startup = context.read(startupNotipod);
    final signalRInit = context.read(signalRInitFpod);

    remoteConfig.when(
      success: () {
        appInit.whenData((_) {
          router.state.when(
            authorized: () {
              startup.authorized.when(
                loading: () => const Loader(
                  color: Colors.lime,
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
            unauthorized: () {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                navigatorPushReplacement(context, const OnBoardingScreen());
              });
            },
          );
        });
      },
      loading: () => const SizedBox(),
    );

    return OnBoardingFullScreenGradient(
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          width: 120.r,
          height: 120.r,
        ),
      ),
    );
  }
}
