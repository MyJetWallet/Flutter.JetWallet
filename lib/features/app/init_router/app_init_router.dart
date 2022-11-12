import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/api_selector_screen/api_selector_screen.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/biometric/ui/biometric.dart';
import 'package:jetwallet/features/auth/onboarding/ui/onboarding_screen.dart';
import 'package:jetwallet/features/auth/single_sign_in/ui/sing_in.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';
import 'package:jetwallet/features/auth/user_data/ui/user_data_screen.dart';
import 'package:jetwallet/features/disclaimer/store/disclaimer_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/ui/pin_screen.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/features/two_fa_phone/ui/two_fa_phone.dart';

class AppInitRouter extends StatelessObserverWidget {
  const AppInitRouter({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appStore = getIt.get<AppStore>();

    return appStore.initRouter.when(
      loading: () {
        return const SplashScreen();
      },
      apiSelector: () {
        return const ApiSelectorScreen();
      },
      singleIn: () {
        return const SingIn();
      },
      userDataVerification: () {
        return const UserDataScreen();
      },
      askBioUsing: () {
        return const Biometric();
      },
      twoFaVerification: () {
        if (sUserInfo.userInfo.hasDisclaimers) {
          getIt<DisclaimerStore>().init();
        }

        return const TwoFaPhone(
          trigger: TwoFaPhoneTriggerUnion.startup(),
        );
      },
      pinSetup: () {
        if (sUserInfo.userInfo.hasDisclaimers) {
          getIt<DisclaimerStore>().init();
        }

        return const PinScreen(
          union: Setup(),
          cannotLeave: true,
        );
      },
      pinVerification: () {
        if (sUserInfo.userInfo.hasDisclaimers) {
          getIt<DisclaimerStore>().init();
        }

        return const PinScreen(
          union: Verification(),
          cannotLeave: true,
          displayHeader: false,
        );
      },
      home: () {
        if (sUserInfo.userInfo.hasDisclaimers) {
          getIt<DisclaimerStore>().init();
        }

        getIt.get<AppStore>().initSessionInfo();

        if (!getIt<RouteQueryService>().isNavigate) {
          getIt<RouteQueryService>().runQuery();
        }

        return child;
      },
      unauthorized: () {
        return const OnboardingScreen();
      },
    );
  }
}
