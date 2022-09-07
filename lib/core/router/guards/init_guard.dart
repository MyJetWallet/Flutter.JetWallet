import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';

class InitGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final appStore = getIt.get<AppStore>();

    if (!getIt.get<DioProxyService>().proxySkiped) {
      if (!router.isPathActive('/api_selector')) {
        unawaited(
          router.push(
            const ApiSelectorRouter(),
          ),
        );
      }

      return;
    }

    if (appStore.remoteConfigStatus == const RemoteConfigUnion.success()) {
      //await appStore.getAuthStatus();

      appStore.authStatus.when(
        loading: () {
          print('InitGuard: loading');

          router.replace(
            const SplashRoute(),
          );
        },
        authorized: () {
          print('InitGuard: authorized');

          appStore.authorizedStatus.when(
            loading: () {
              print('InitGuard: loading');

              router.replace(
                const SplashRoute(),
              );
            },
            emailVerification: () {
              print('InitGuard: emailVerification');

              //router.push(
              //  const EmailVerificationRoute(),
              //);
            },
            twoFaVerification: () {
              print('InitGuard: twoFaVerification');

              router.push(
                TwoFaPhoneRouter(
                  trigger: const TwoFaPhoneTriggerUnion.startup(),
                ),
              );
            },
            pinSetup: () {
              print('InitGuard: pinSetup');

              router.push(
                PinScreenRoute(
                  union: const PinFlowUnion.setup(),
                  cannotLeave: true,
                ),
              );
            },
            pinVerification: () {
              print('InitGuard: pinVerification');

              router.push(
                PinScreenRoute(
                  union: const PinFlowUnion.verification(),
                  cannotLeave: true,
                  displayHeader: false,
                ),
              );
            },
            home: () {
              print('InitGuard: home');

              resolver.next();
            },
            askBioUsing: () {
              router.push(
                BiometricRouter(),
              );
            },
            singleIn: () {
              router.push(
                SingInRouter(),
              );
            },
            userDataVerification: () {
              router.push(
                const UserDataScreenRouter(),
              );
            },
          );
        },
        unauthorized: () {
          print('InitGuard: unauthorized');

          router.push(
            const OnboardingRoute(),
          );
        },
      );
    } else {
      await router.push(
        const SplashRoute(),
      );
    }
  }
}
