import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routeInformationParser: getIt.get<AppRouter>().defaultRouteParser(),
      routerDelegate: getIt.get<AppRouter>().delegate(),
      builder: builder ?? (_, child) => AppBuilder(child),
    );
  }
}
