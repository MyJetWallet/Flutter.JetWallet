import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'development/api_selector_screen.dart';
import 'router/view/router.dart';
import 'shared/logging/debug_logging.dart';
import 'shared/logging/provider_logger.dart';
import 'shared/providers/background/initialize_background_providers.dart';
import 'shared/providers/other/navigator_key_pod.dart';
import 'shared/services/push_notification_service.dart';
import 'shared/services/remote_config_service/service/remote_config_service.dart';

// Just type providers here to exclude from logger
// Remember to unstage the changes from your commit
final providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeStreamProvider<PricesModel>',
];

final providerNames = <String>[
  'logRecordsNotipod',
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    await PushNotificationService().initialize();
    await RemoteConfigService().fetchAndActivate();
  }

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
    final navigatorKey = useProvider(navigatorKeyPod);

    return ScreenUtilInit(
      designSize: const Size(360, 640), // 9/16 ratio
      builder: () {
        return MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          initialRoute: ApiSelectorScreen.routeName,
          navigatorKey: navigatorKey,
          routes: {
            AppRouter.routeName: (context) => AppRouter(),
            ApiSelectorScreen.routeName: (context) => ApiSelectorScreen(),
          },
        );
      },
    );
  }
}
