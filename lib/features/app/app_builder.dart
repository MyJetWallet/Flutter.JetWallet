import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jetwallet/core/services/internet_checker_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';

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

    final _logger = Logger('AppBuilder');

    return Builder(
      builder: (context) {
        getIt.get<DeviceSize>().setSize(reactiveMediaQuery.size.height);

        /// Register AppLocalizations, register here, because we need context
        if (!getIt.isRegistered<AppLocalizations>()) {
          getIt.registerSingleton<AppLocalizations>(
            AppLocalizations.of(
              context,
            )!,
          );
        }

        return Observer(
          builder: (context) {
            _logger.log(
              notifier,
              'remoteConfigStatus ${getIt.get<AppStore>().remoteConfigStatus}',
            );

            return getIt.get<AppStore>().remoteConfigStatus is Success
                ? FutureBuilder(
                    future: getIt.allReady(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      _logger.log(notifier, snapshot.connectionState);

                      if (snapshot.hasError) {
                        _logger.log(stateFlow, 'ERROR ${snapshot.error}');
                      }

                      return snapshot.hasData
                          ? Builder(
                              builder: (context) {
                                return AppBuilderBody(
                                  reactiveMediaQuery: reactiveMediaQuery,
                                  child: child ??
                                      const SplashScreen(
                                        runAnimation: false,
                                      ),
                                );
                              },
                            )
                          : const SplashScreen(
                              runAnimation: false,
                            );
                    },
                  )
                : const SplashScreen();
          },
        );
      },
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

  static restart(BuildContext context) {
    context.findAncestorStateOfType<_AppBuilderBodyState>()!.restartApp();
  }
}

class _AppBuilderBodyState extends State<AppBuilderBody> {
  @override
  void initState() {
    print('INIT GET AUTH STATE');
    getIt.get<AppStore>().getAuthStatus();
    super.initState();
  }

  Key _key = UniqueKey();

  Future<void> restartApp() async {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      key: _key,
      data: widget.reactiveMediaQuery.copyWith(
        textScaleFactor: 1.0,
      ),
      child: widget.child,
    );
  }
}
