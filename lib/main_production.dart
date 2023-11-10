import 'dart:async';
import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/app/app.dart';
import 'package:jetwallet/features/app/app_initialization.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      await appInitialization('prod');

      runApp(const AppScreen());
    },
    (error, stackTrace) {
      Logger.root.log(Level.SEVERE, 'ZonedGuarded', error, stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );

  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {}).sendPort,
  );

  //await OneSignal.shared.setAppId('e192e9ee-288c-46fd-942f-a2f1b479f4b8');
}
