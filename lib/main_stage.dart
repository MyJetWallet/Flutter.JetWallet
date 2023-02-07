import 'dart:async';
import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/features/app/app.dart';
import 'package:jetwallet/features/app/app_initialization.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';

Future<void> main() async {
  mainContext.onReactionError((_, rxn) {
    //log.error('A mobx reaction error occured.'
    //,error: rxn.errorValue!.exception,);
  });

  await appInitialization('stage');

  runZonedGuarded(
    () => runApp(
      const AppScreen(
        isStageEnv: true,
        debugShowCheckedModeBanner: false,
      ),
    ),
    (error, stackTrace) {
      Logger.root.log(Level.SEVERE, 'ZonedGuarded', error, stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );

  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      final errorAndStacktrace = pair as List;

      /*
      log.error(
        'An error was captured by main.Isolate.current.addErrorListener',
        error: errorAndStacktrace.first,
      );
      */
    }).sendPort,
  );

  //await OneSignal.shared.setAppId('e192e9ee-288c-46fd-942f-a2f1b479f4b8');
}
