import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'router/view/router.dart';
import 'shared/logging/provider_logger.dart';
import 'shared/providers/background/initialize_background_providers.dart';
import 'shared/providers/other/navigator_key_pod.dart';
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
  await PushNotificationService().initialize(); // doesn't work on web

  Logger.root.level = Level.ALL;

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(
          ignoreByType: providerTypes,
          ignoreByName: providerNames,
        ),
      ],
      child: App(),
    ),
  );
}

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    final navigatorKey = useProvider(navigatorKeyPod);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: AppRouter.routeName,
          navigatorKey: navigatorKey,
          routes: {
            AppRouter.routeName: (context) => const AppRouter(),
          },
        );
      },
    );
  }
}
