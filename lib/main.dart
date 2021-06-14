import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

import 'router/view/router.dart';
import 'shared/logging/debug_logging.dart';
import 'shared/provider_logger.dart';
import 'shared/services/firebase_messaging_service.dart';
import 'shared/theme/theme_data.dart';

// Just type providers here to exclude from logger
// Remember to unstage the changes from your commit
final providers = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeStreamProvider<PricesModel>',
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await registerFirebaseMessaging();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) => debugLogging(record));

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(
          exludedProviders: providers,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: AppRouter.routeName,
      routes: {
        AppRouter.routeName: (context) => AppRouter(),
      },
    );
  }
}
