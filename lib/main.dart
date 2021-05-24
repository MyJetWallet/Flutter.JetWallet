import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'router/view/router.dart';
import 'shared/provider_logger.dart';
import 'shared/theme/theme_data.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
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
