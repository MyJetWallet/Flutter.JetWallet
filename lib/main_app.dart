import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jetwallet/global/theme.dart';
import 'package:jetwallet/spot_home/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'global/translations.dart';

Store<AppState> buildStore() => Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [
        thunkMiddleware,
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
        title: 'Spot Jet Wallet',
        theme: globalSpotTheme,
        home: const SizedBox(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, widget) {
          return const SizedBox();
        },
        supportedLocales: t.supportedLocales(),
        routes: <String, WidgetBuilder>{
          '/login': (context) => const SizedBox(),
          '/home': (context) => const SizedBox(),
        },
      ),
    );
  }
}
