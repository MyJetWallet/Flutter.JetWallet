import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';

final _logger = Logger('InitGuard');

class InitGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final appStore = getIt.get<AppStore>();
    final flavor = flavorService();

    if (flavor != Flavor.prod && !getIt.get<DioProxyService>().proxySkiped) {
      print('API SELECTOR');
      if (!router.isPathActive('/api_selector')) {
        print('API SELECTOR');

        await router.pushAndPopUntil(
          const ApiSelectorRouter(),
          predicate: (r) => true,
        );

        return;
      }
    }

    if (appStore.remoteConfigStatus == const RemoteConfigUnion.success()) {
      //await appStore.getAuthStatus();

      print('Remote Status Success');
      _logger.log(notifier, 'Remote Status Success');

      appStore.authStatus.when(
        loading: () {
          print('InitGuard authStatus: loading');
          _logger.log(notifier, 'AuthStatus: Loading');

          router.replace(
            const SplashRoute(),
          );
        },
        authorized: () {
          print('InitGuard: authorized');
          _logger.log(notifier, 'AuthStatus: Authorized');

          appStore.authorizedStatus.when(
            loading: () {
              print('InitGuard authorizedStatus: loading');
              _logger.log(notifier, 'AuthStatus: Loading');

              router.replace(
                const SplashRoute(),
              );
            },
            emailVerification: () {
              print('InitGuard: emailVerification');
              _logger.log(notifier, 'AuthStatus: EmailVerification');

              //router.push(
              //  const EmailVerificationRoute(),
              //);
            },
            twoFaVerification: () {
              print('InitGuard: twoFaVerification');
              _logger.log(notifier, 'AuthStatus: TwoFaVerification');

              router.push(
                TwoFaPhoneRouter(
                  trigger: const TwoFaPhoneTriggerUnion.startup(),
                ),
              );
            },
            pinSetup: () {
              print('InitGuard: pinSetup');
              _logger.log(notifier, 'AuthStatus: PinSetup');

              router.push(
                PinScreenRoute(
                  union: const PinFlowUnion.setup(),
                  cannotLeave: true,
                ),
              );
            },
            pinVerification: () {
              print('InitGuard: pinVerification');
              _logger.log(notifier, 'AuthStatus: PinVerification');

              getIt.get<UserInfoService>().initPinStatus();

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
              _logger.log(notifier, 'AuthStatus: Home');

              getIt.get<AppStore>().initSessionInfo();

              resolver.next();
            },
            askBioUsing: () {
              _logger.log(notifier, 'AuthStatus: AskBioUsing');

              router.push(
                BiometricRouter(),
              );
            },
            singleIn: () {
              _logger.log(notifier, 'AuthStatus: SingInRouter');

              router.push(
                SingInRouter(),
              );
            },
            userDataVerification: () {
              _logger.log(notifier, 'AuthStatus: UserDataScreenRouter');

              router.push(
                const UserDataScreenRouter(),
              );
            },
          );
        },
        unauthorized: () {
          print('InitGuard: unauthorized');
          _logger.log(notifier, 'AuthStatus: OnboardingRoute');

          router.push(
            const OnboardingRoute(),
          );
        },
      );
    } else {
      _logger.log(notifier, 'AuthStatus: SplashRoute');

      await router.replace(
        const SplashRoute(),
      );
    }
  }
}
