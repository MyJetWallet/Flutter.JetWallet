import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import 'development/app_router_stage/app_router_stage.dart';
import 'router/view/components/app_init.dart';
import 'shared/components/app_builder.dart';
import 'shared/logging/provider_logger.dart';
import 'shared/providers/background/initialize_background_providers.dart';
import 'shared/providers/device_uid_pod.dart';
import 'shared/providers/package_info_fpod.dart';
import 'shared/services/push_notification_service.dart';

final providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<ChartNotifier, ChartState>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
  'AutoDisposeStateNotifierProvider<ConvertInputNotifier, ConvertInputState>',
];

final providerNames = <String>[
  'logRecordsNotipod',
  'timerNotipod',
];

/// TODO refactor to single instance
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make android status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp();
  await PushNotificationService().initialize();

  Logger.root.level = Level.ALL;

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ProviderScope(
        observers: [
          ProviderLogger(
            ignoreByType: providerTypes,
            ignoreByName: providerNames,
          ),
        ],
        child: App(),
      ),
    ),
  );
}

/// TODO refactor to single instance
class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    useProvider(deviceUidPod);
    useProvider(packageInfoFpod);
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          navigatorKey: navigatorKey,
          builder: (context, child) {
            child = DevicePreview.appBuilder(context, child);
            child = AppBuilder(child);

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child,
            );
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: AppRouterStage.routeName,
          routes: {
            AppRouterStage.routeName: (context) => const AppRouterStage(),
            AppInit.routeName: (context) => const AppInit(),
          },
        );
      },
    );
  }
}
