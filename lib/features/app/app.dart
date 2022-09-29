import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/dynamic_link_service.dart';
import 'package:jetwallet/core/services/logs/log_record_service.dart';
import 'package:jetwallet/core/services/push_notification.dart';
import 'package:jetwallet/features/app/app_builder.dart';

class AppScreen extends StatefulWidget {
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
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    /// Init DeepLinks
    getIt.registerSingletonAsync<DeviceInfo>(
      () async => DeviceInfo().deviceInfo(),
    );

    getIt.registerSingletonWithDependencies<DynamicLinkService>(
      () => DynamicLinkService()..initDynamicLinks(),
      dependsOn: [DeviceInfo],
    );

    getIt.registerSingleton<PushNotification>(
      PushNotification(),
    );

    getIt.registerSingleton<LogRecordsService>(
      LogRecordsService(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      locale: widget.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
        Locale('es'),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routeInformationParser: getIt.get<AppRouter>().defaultRouteParser(),
      routerDelegate: getIt.get<AppRouter>().delegate(),
      builder: widget.builder ?? (_, child) => AppBuilder(child),
    );
  }
}
