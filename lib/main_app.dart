import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jetwallet/app_navigator/navigator_middleware.dart';
import 'package:jetwallet/global/theme.dart';
import 'package:jetwallet/screens/home/home_screen.dart';
import 'package:jetwallet/screens/loader/loader.dart';
import 'package:jetwallet/screens/login/login_screen.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/login/registration/registration_screen.dart';
import 'package:jetwallet/screens/notifier/notifier.dart';
import 'package:jetwallet/screens/splash/splash_screen.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'global/translations.dart';

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
