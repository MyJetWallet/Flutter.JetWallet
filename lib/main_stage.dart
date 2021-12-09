import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
import 'shared/providers/device_uid_pod.dart';
import 'shared/services/push_notification_service.dart';

final providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
];

final providerNames = <String>[
  'logRecordsNotipod',
  'timerNotipod',
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    useProvider(deviceUidPod);
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
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child ?? const SizedBox(),
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
