import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import 'router/view/router.dart';
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
    useProvider(deviceUidPod);
    useProvider(packageInfoFpod);
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return CupertinoApp(
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
          initialRoute: AppRouter.routeName,
          routes: {
            AppRouter.routeName: (context) => const AppRouter(),
          },
        );
      },
    );
  }
}
