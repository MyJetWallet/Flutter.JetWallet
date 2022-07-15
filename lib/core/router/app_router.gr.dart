// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter(
      {GlobalKey<NavigatorState>? navigatorKey, required this.initGuard})
      : super(navigatorKey);

  final InitGuard initGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const SplashScreen());
    },
    OnboardingRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const OnboardingScreen());
    },
    LoginScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LoginScreenRouteArgs>(
          orElse: () => const LoginScreenRouteArgs());
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: LoginScreen(key: args.key, email: args.email));
    },
    RegisterRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const RegisterScreen());
    },
    RegisterPasswordRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const RegisterPasswordScreen());
    },
    AllowCameraRoute.name: (routeData) {
      final args = routeData.argsAs<AllowCameraRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: AllowCameraScreen(
              key: args.key,
              permissionDescription: args.permissionDescription,
              then: args.then));
    },
    HomeRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const HomeScreen());
    },
    MarketRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const MarketScreen());
    },
    PortfolioRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const PortfolioScreen());
    },
    NewsRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const NewsScreen());
    },
    AccountRouter.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const AccountScreen());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig('/#redirect',
            path: '/', redirectTo: '/home', fullMatch: true),
        RouteConfig(SplashRoute.name, path: '/splash'),
        RouteConfig(OnboardingRoute.name, path: '/splash_screen'),
        RouteConfig(LoginScreenRoute.name, path: '/login'),
        RouteConfig(RegisterRoute.name, path: '/register'),
        RouteConfig(RegisterPasswordRoute.name, path: '/register_password'),
        RouteConfig(AllowCameraRoute.name, path: '/allow_camera'),
        RouteConfig(HomeRouter.name, path: '/home', guards: [
          initGuard
        ], children: [
          RouteConfig('#redirect',
              path: '',
              parent: HomeRouter.name,
              redirectTo: 'market',
              fullMatch: true),
          RouteConfig(MarketRouter.name,
              path: 'market', parent: HomeRouter.name),
          RouteConfig(PortfolioRouter.name,
              path: 'portfolio', parent: HomeRouter.name),
          RouteConfig(NewsRouter.name, path: 'news', parent: HomeRouter.name),
          RouteConfig(AccountRouter.name,
              path: 'account', parent: HomeRouter.name)
        ])
      ];
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute() : super(OnboardingRoute.name, path: '/splash_screen');

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [LoginScreen]
class LoginScreenRoute extends PageRouteInfo<LoginScreenRouteArgs> {
  LoginScreenRoute({Key? key, String? email})
      : super(LoginScreenRoute.name,
            path: '/login', args: LoginScreenRouteArgs(key: key, email: email));

  static const String name = 'LoginScreenRoute';
}

class LoginScreenRouteArgs {
  const LoginScreenRouteArgs({this.key, this.email});

  final Key? key;

  final String? email;

  @override
  String toString() {
    return 'LoginScreenRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: '/register');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [RegisterPasswordScreen]
class RegisterPasswordRoute extends PageRouteInfo<void> {
  const RegisterPasswordRoute()
      : super(RegisterPasswordRoute.name, path: '/register_password');

  static const String name = 'RegisterPasswordRoute';
}

/// generated route for
/// [AllowCameraScreen]
class AllowCameraRoute extends PageRouteInfo<AllowCameraRouteArgs> {
  AllowCameraRoute(
      {Key? key,
      required String permissionDescription,
      required void Function() then})
      : super(AllowCameraRoute.name,
            path: '/allow_camera',
            args: AllowCameraRouteArgs(
                key: key,
                permissionDescription: permissionDescription,
                then: then));

  static const String name = 'AllowCameraRoute';
}

class AllowCameraRouteArgs {
  const AllowCameraRouteArgs(
      {this.key, required this.permissionDescription, required this.then});

  final Key? key;

  final String permissionDescription;

  final void Function() then;

  @override
  String toString() {
    return 'AllowCameraRouteArgs{key: $key, permissionDescription: $permissionDescription, then: $then}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRouter extends PageRouteInfo<void> {
  const HomeRouter({List<PageRouteInfo>? children})
      : super(HomeRouter.name, path: '/home', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [MarketScreen]
class MarketRouter extends PageRouteInfo<void> {
  const MarketRouter() : super(MarketRouter.name, path: 'market');

  static const String name = 'MarketRouter';
}

/// generated route for
/// [PortfolioScreen]
class PortfolioRouter extends PageRouteInfo<void> {
  const PortfolioRouter() : super(PortfolioRouter.name, path: 'portfolio');

  static const String name = 'PortfolioRouter';
}

/// generated route for
/// [NewsScreen]
class NewsRouter extends PageRouteInfo<void> {
  const NewsRouter() : super(NewsRouter.name, path: 'news');

  static const String name = 'NewsRouter';
}

/// generated route for
/// [AccountScreen]
class AccountRouter extends PageRouteInfo<void> {
  const AccountRouter() : super(AccountRouter.name, path: 'account');

  static const String name = 'AccountRouter';
}
