import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/internet_checker_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/timer_service.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';
import 'package:logger/logger.dart';

import '../../core/services/remote_config/models/remote_config_union.dart';

class AppBuilder extends StatelessObserverWidget {
  const AppBuilder(this.child);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // mediaQuery = useMemoized(() => MediaQuery.of(context));
    // reactiveMediaQuery is needed to update viewInsets and
    // other stuff when it changes.
    // In the case above changes are unwanted, so we placed
    // mediaQuery inside useMemorized hook
    final reactiveMediaQuery = MediaQuery.of(context);

    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Observer(
        builder: (context) {
          getIt.get<DeviceSize>().setSize(reactiveMediaQuery.size.height);

          /// Register AppLocalizations, register here, because we need context
          if (!getIt.isRegistered<AppLocalizations>()) {
            getIt.registerSingleton<AppLocalizations>(
              AppLocalizations.of(context)!,
            );

            if (getIt.isRegistered<AppStore>()) {
              getIt.get<AppStore>().initLocale(context: context);
            }
          }

          return getIt.get<AppStore>().remoteConfigStatus is Success
              ? AppBuilderBody(
                  reactiveMediaQuery: reactiveMediaQuery,
                  child: child ?? const SplashScreen(),
                )
              : const SplashScreen();
        },
      ),
    );
  }
}

class AppBuilderBody extends StatefulWidget {
  const AppBuilderBody({
    super.key,
    required this.child,
    required this.reactiveMediaQuery,
  });

  final Widget child;
  final MediaQueryData reactiveMediaQuery;

  @override
  State<AppBuilderBody> createState() => _AppBuilderBodyState();
}

class _AppBuilderBodyState extends State<AppBuilderBody> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'AppBuilder',
            message: 'AppLifecycleState RESUMED',
          );

      if (getIt.get<AppStore>().authStatus == const AuthorizationUnion.authorized()) {
        refreshToken(
          isResumed: true,
        );
      }

      if (getIt.isRegistered<InternetCheckerService>()) {
        getIt<InternetCheckerService>().checkFromForeground();
      }

      getIt.get<RemoteConfig>().pingRemoutConfig();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getIt.get<StartupService>().firstAction();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimerServiceProvider(
      service: getIt<TimerService>(),
      child: SimpleActivityDetector(
        onShoulNavigate: (_) {},
        child: MediaQuery(
          data: widget.reactiveMediaQuery.copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: GlobalLoaderWidget(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
