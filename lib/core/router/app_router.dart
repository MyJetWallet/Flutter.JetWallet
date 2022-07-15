import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/router/guards/init_guard.dart';
import 'package:jetwallet/features/account/account_screen.dart';
import 'package:jetwallet/features/auth/email_verification/ui/email_verification_screen.dart';
import 'package:jetwallet/features/auth/forgot_password/ui/forgot_password_screen.dart';
import 'package:jetwallet/features/auth/login/ui/login_screen.dart';
import 'package:jetwallet/features/auth/onboarding/ui/onboarding_screen.dart';
import 'package:jetwallet/features/auth/register/ui/register_password_screen.dart';
import 'package:jetwallet/features/auth/register/ui/register_screen.dart';
import 'package:jetwallet/features/auth/reset_password/ui/reset_password_screen.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';
import 'package:jetwallet/features/home/home_screen.dart';
import 'package:jetwallet/features/kyc/allow_camera/ui/allow_camera_screen.dart';
import 'package:jetwallet/features/market/market_screen.dart';
import 'package:jetwallet/features/news/news_screen.dart';
import 'package:jetwallet/features/portfolio/portfolio_screen.dart';

part 'app_router.gr.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/splash',
      name: 'SplashRoute',
      page: SplashScreen,
    ),
    AutoRoute(
      path: '/splash_screen',
      name: 'OnboardingRoute',
      page: OnboardingScreen,
    ),
    AutoRoute(
      path: '/login',
      name: 'LoginScreenRoute',
      page: LoginScreen,
    ),
    AutoRoute(
      path: '/register',
      name: 'RegisterRoute',
      page: RegisterScreen,
    ),
    AutoRoute(
      path: '/register_password',
      name: 'RegisterPasswordRoute',
      page: RegisterPasswordScreen,
    ),
    AutoRoute(
      path: '/email_verification',
      name: 'EmailVerificationRoute',
      page: EmailVerificationScreen,
    ),
    AutoRoute(
      path: '/forgot_password',
      name: 'ForgotPasswordRoute',
      page: ForgotPasswordScreen,
    ),
    AutoRoute(
      path: '/reset_password',
      name: 'ResetPasswordRoute',
      page: ResetPasswordScreen,
    ),
    AutoRoute(
      path: '/allow_camera',
      name: 'AllowCameraRoute',
      page: AllowCameraScreen,
    ),
    AutoRoute(
      initial: true,
      guards: [InitGuard],
      path: '/home',
      name: 'HomeRouter',
      page: HomeScreen,
      children: [
        AutoRoute(
          path: 'market',
          name: 'MarketRouter',
          page: MarketScreen,
          initial: true,
        ),
        AutoRoute(
          path: 'portfolio',
          name: 'PortfolioRouter',
          page: PortfolioScreen,
        ),
        AutoRoute(
          path: 'news',
          name: 'NewsRouter',
          page: NewsScreen,
        ),
        AutoRoute(
          path: 'account',
          name: 'AccountRouter',
          page: AccountScreen,
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required super.initGuard});
}
