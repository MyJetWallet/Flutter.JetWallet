import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import 'development/app_router_stage/app_router_stage.dart';
import 'router/view/components/app_init.dart';
import 'shared/logging/provider_logger.dart';
import 'shared/providers/background/initialize_background_providers.dart';
import 'shared/services/push_notification_service.dart';

final providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
];

final providerNames = <String>[
  'logRecordsNotipod',
  'timerNotipod',
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
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

class App extends StatefulHookWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      /// Set highest refresh rate that is supported by device
      await FlutterDisplayMode.setHighRefreshRate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return MaterialApp(
          theme: theme,
          home: Stack(
            children: [
              MaterialApp(
                theme: theme,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                debugShowCheckedModeBanner: false,
                initialRoute: AppRouterStage.routeName,
                navigatorKey: navigatorKey,
                routes: {
                  AppRouterStage.routeName: (context) => const AppRouterStage(),
                  AppInit.routeName: (context) => const AppInit(),
                },
              ),
              // const LogsPersistantButton(),
            ],
          ),
        );
      },
    );
  }
}
