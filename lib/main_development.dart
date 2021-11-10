import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import 'router/view/router.dart';
import 'shared/logging/debug_logging.dart';
import 'shared/logging/provider_logger.dart';
import 'shared/providers/background/initialize_background_providers.dart';
import 'shared/services/push_notification_service.dart';

final providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<ChartNotifier, ChartState>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
];

final providerNames = <String>[
  'logRecordsNotipod',
];

// test comment

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationService().initialize();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) => debugLogging(record));

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

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        /// Second material is placed to mimic structure of stage_env
        /// Because there are some issues with nested MaterialApps
        /// So, stage_env can be broken while dev_env is working fine
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: MaterialApp(
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRouter.routeName,
            navigatorKey: navigatorKey,
            routes: {
              AppRouter.routeName: (context) => const AppRouter(),
            },
          ),
        );
      },
    );
  }
}
