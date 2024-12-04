import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/dynamic_link_service.dart';
import 'package:jetwallet/core/services/push_notification.dart';
import 'package:jetwallet/features/app/app_builder.dart';
import 'package:jetwallet/features/app/route_observer.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({
    super.key,
    this.locale,
    this.builder,
    this.isStageEnv = false,
    this.debugShowCheckedModeBanner = true,
  });

  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final bool isStageEnv;
  final bool debugShowCheckedModeBanner;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _logger = Logger('AppScreen');

  @override
  void initState() {
    /// Init DeepLinks
    try {
      getIt.registerSingletonAsync<DeviceInfo>(
        () async => DeviceInfo().deviceInfo(),
        signalsReady: false,
      );

      if (kIsWeb) {
        getIt.registerSingletonWithDependencies<DynamicLinkService>(
          () => DynamicLinkService(),
          dependsOn: [DeviceInfo],
          signalsReady: false,
        );
      } else {
        getIt.registerSingletonWithDependencies<DynamicLinkService>(
          () => DynamicLinkService()..initDynamicLinks(),
          dependsOn: [DeviceInfo],
          signalsReady: false,
        );
      }

      getIt.registerSingleton<PushNotification>(
        PushNotification(),
      );
    } catch (e) {
      _logger.log(
        notifier,
        e,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: SentryAssetBundle(),
      child: CupertinoApp.router(
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        locale: getIt.get<AppStore>().locale,
        title: 'Simple',
        supportedLocales: const [
          Locale('en'),
          Locale('pl'),
          Locale('uk'),
          Locale('es'),
          Locale('fr'),
        ],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routeInformationParser: getIt.get<AppRouter>().defaultRouteParser(),
        //routerDelegate: getIt.get<AppRouter>().delegate(),
        routerDelegate: AutoRouterDelegate(
          getIt.get<AppRouter>(),
          navigatorObservers: () => [
            SimpleRouteObserver(),
            SentryNavigatorObserver(),
          ],
        ),
        builder: (_, child) => AppBuilder(child),
      ),
    );
  }
}
