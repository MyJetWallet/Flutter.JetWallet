import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../auth/screens/forgot_password/view/confirm_password_reset.dart';
import '../../auth/screens/forgot_password/view/forgot_password.dart';
import '../../auth/screens/login/login.dart';
import '../../auth/screens/register/register.dart';
import '../../auth/screens/register/register_password_screen.dart';
import '../../auth/screens/reset_password/view/reset_password.dart';
import '../../router/view/router.dart';
import '../../shared/logging/provider_logger.dart';
import '../../shared/providers/background/initialize_background_providers.dart';
import '../../shared/providers/device_info_pod.dart';
import '../../shared/providers/package_info_fpod.dart';
import '../stage/app_router_stage/app_router_stage.dart';
import '../stage/components/app_init.dart';
import 'app_builder.dart';

final _providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<ChartNotifier, ChartState>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
  'AutoDisposeStateNotifierProvider<ConvertInputNotifier, ConvertInputState>',
  'AutoDisposeStreamProvider<PriceAccuracies>',
  'AutoDisposeStreamProvider<AssetsModel>',
  'AutoDisposeStreamProvider<BalancesModel>',
  'AutoDisposeStreamProvider<KycCountriesResponseModel>',
  'AutoDisposeStateNotifierProvider<KycCountriesNotifier, KycCountriesState>',
  'AutoDisposeStreamProvider<MarketReferencesModel>',
  'AutoDisposeStreamProvider<CampaignResponseModel>',
  'AutoDisposeProvider<List<CampaignModel>>',
  'AutoDisposeStateNotifierProvider<CampaignNotifier, List<CampaignModel>>',
  'AutoDisposeStateNotifierProvider<CurrencyBuyNotifier, CurrencyBuyState>',
];

final _providerNames = <String>[
  'logRecordsNotipod',
  'timerNotipod',
  'convertPriceAccuraciesPod',
];

class App extends HookWidget {
  const App({
    Key? key,
    this.locale,
    this.builder,
    this.isStageEnv = false,
    this.debugShowCheckedModeBanner = true,
  }) : super(key: key);

  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final bool isStageEnv;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [
        ProviderLogger(
          ignoreByType: _providerTypes,
          ignoreByName: _providerNames,
        ),
      ],
      child: _App(
        locale: locale,
        builder: builder,
        isStageEnv: isStageEnv,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      ),
    );
  }
}

class _App extends HookWidget {
  const _App({
    Key? key,
    this.locale,
    this.builder,
    this.isStageEnv = false,
    this.debugShowCheckedModeBanner = true,
  }) : super(key: key);

  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final bool isStageEnv;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    useProvider(deviceInfoPod);
    useProvider(packageInfoFpod);
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);

    return CupertinoApp(
      restorationScopeId: 'app',
      locale: locale,
      theme: theme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      builder: builder ?? (_, child) => AppBuilder(child),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: isStageEnv ? AppRouterStage.routeName : AppRouter.routeName,
      routes: {
        AppRouter.routeName: (_) {
          return const AppRouter();
        },
        // [START] Stage only routes ->
        AppRouterStage.routeName: (_) {
          return const AppRouterStage();
        },
        AppInit.routeName: (_) {
          return const AppInit();
        },
        // <- Stage only routes [END]
        RegisterPasswordScreen.routeName: (_) {
          return const RegisterPasswordScreen();
        },
        ResetPassword.routeName: (_) {
          return const ResetPassword();
        },
        Login.routeName: (_) {
          return const Login();
        },
        Register.routeName: (_) {
          return const Register();
        },
        ForgotPassword.routeName: (_) {
          return const ForgotPassword();
        },
        ConfirmPasswordReset.routeName: (_) {
          return const ConfirmPasswordReset();
        },
      },
    );
  }
}
