import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';

class InitGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final appStore = getIt.get<AppStore>();

    await appStore.getAuthStatus();

    appStore.authStatus.when(
      authorized: () {
        print('InitGuard: authorized');

        appStore.authorizedStatus.when(
          loading: () {
            print('InitGuard: loading');

            router.push(
              const OnboardingRoute(),
            );
          },
          emailVerification: () {
            print('InitGuard: emailVerification');

            router.push(
              const SplashRoute(),
            );
          },
          twoFaVerification: () {
            print('InitGuard: twoFaVerification');

            router.push(
              const SplashRoute(),
            );
          },
          pinSetup: () {
            print('InitGuard: pinSetup');

            router.push(
              const SplashRoute(),
            );
          },
          pinVerification: () {
            print('InitGuard: pinVerification');

            router.push(
              const SplashRoute(),
            );
          },
          home: () {
            print('InitGuard: home');

            resolver.next();
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
  }
}
