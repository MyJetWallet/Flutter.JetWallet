import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../router/view/components/app_init.dart';
import '../../router/view/router.dart';
import '../../shared/logging/provider_logger.dart';
import '../../shared/providers/background/initialize_background_providers.dart';
import '../../shared/providers/device_uid_pod.dart';
import '../../shared/providers/package_info_fpod.dart';
import '../stage/app_router_stage/app_router_stage.dart';
import 'app_builder.dart';

final _providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<ChartNotifier, ChartState>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
  'AutoDisposeStateNotifierProvider<ConvertInputNotifier, ConvertInputState>',
];

final _providerNames = <String>[
  'logRecordsNotipod',
  'timerNotipod',
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
    useProvider(deviceUidPod);
    useProvider(packageInfoFpod);
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);

    /// TODO remove ScreenUtilInit
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return CupertinoApp(
          locale: locale,
          theme: theme,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          builder: builder ?? (_, child) => AppBuilder(child),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute:
              isStageEnv ? AppRouterStage.routeName : AppRouter.routeName,
          routes: {
            AppRouter.routeName: (_) => const AppRouter(),
            // [START] Stage only routes ->
            AppRouterStage.routeName: (context) => const AppRouterStage(),
            AppInit.routeName: (context) => const AppInit(),
            // <- Stage only routes [END]
          },
        );
      },
    );
  }
}
