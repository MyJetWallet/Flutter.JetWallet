import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/app_builder.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    Key? key,
    this.locale,
    this.builder,
    this.isStageEnv = false,
    this.debugShowCheckedModeBanner = true,
  }) : super(key: key);

  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final bool isStageEnv;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      restorationScopeId: 'app',
      //theme: theme,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      /*
          supportedLocales: supportedL10nLanguages
              .map(
                (language) => Locale(
                  language.locale,
                  language.countryCode,
                ),
              )
              .toList(),
          localizationsDelegates: [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) {
              return supportedLocales.first;
            }

            // Check if the current device locale is supported
            return supportedLocales.firstWhere(
              (supportedLocale) =>
                  supportedLocale.languageCode == locale.languageCode,
              orElse: () => supportedLocales.first,
            );
          },
          */
      routeInformationParser: getIt.get<AppRouter>().defaultRouteParser(),
      routerDelegate: getIt.get<AppRouter>().delegate(),
      builder: builder ?? (_, child) => AppBuilder(child),
    );
  }
}
