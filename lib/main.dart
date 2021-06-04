import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'router/view/router.dart';
import 'shared/provider_logger.dart';
import 'shared/theme/theme_data.dart';

// Just type providers here to exclude from logger
// Remember to unstage the changes from your commit
final providers = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeStreamProvider<PricesModel>',
];

void main() {
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
