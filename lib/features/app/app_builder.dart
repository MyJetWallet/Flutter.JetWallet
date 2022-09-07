import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jetwallet/core/services/internet_checker_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/splash/splash_screen.dart';

class AppBuilder extends StatelessWidget {
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

        return FutureBuilder(
          future: getIt.allReady(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? Builder(
                    builder: (context) {
                      return AppBuilderBody(
                        reactiveMediaQuery: reactiveMediaQuery,
                        child: child ?? const SizedBox(),
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
}

class _AppBuilderBodyState extends State<AppBuilderBody> {
  @override
  void initState() {
    getIt.get<AppStore>().getAuthStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: widget.reactiveMediaQuery.copyWith(
        textScaleFactor: 1.0,
      ),
      child: widget.child,
    );
  }
}
