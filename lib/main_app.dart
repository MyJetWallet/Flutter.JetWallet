import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'app_navigator/navigator_middleware.dart';
import 'app_state.dart';
import 'global/theme.dart';
import 'global/translations.dart';
import 'screens/home/home_screen.dart';
import 'screens/loader/loader.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/registration/registration_screen.dart';
import 'screens/notifier/notifier.dart';
import 'screens/splash/splash_screen.dart';

Store<AppState> buildStore() => Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [
        thunkMiddleware,
        navigatorMiddleware,
        LoggingMiddleware.printer(),
      ],
    );

class MainApp extends StatelessWidget {
  const MainApp({
    required this.store,
    Key? key,
  }) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorKey: AppNavigator.navigatorKey,
        title: 'Spot Jet Wallet',
        theme: globalSpotTheme,
        home: SplashScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (_, widget) {
          return Stack(
            children: [
              widget ?? Container(),
              const Loader(),
              const Notifier(),
            ],
          );
        },
        supportedLocales: t.supportedLocales(),
        routes: <String, WidgetBuilder>{
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/registration': (context) => const RegistrationScreen(),
        },
      ),
    );
  }
}
