import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

import 'core/app/app.dart';
import 'core/app/app_initialization.dart';
import 'shared/logging/debug_logging.dart';

Future<void> main() async {
  await appInitialization();

  Logger.root.onRecord.listen((record) => debugLogging(record));

  runZonedGuarded(() {
    runApp(
      const App(
        isStageEnv: true,
        debugShowCheckedModeBanner: false,
      ),
    );
  }, (error, stackTrace) {
    Logger.root.log(Level.SEVERE, 'ZonedGuarded', error, stackTrace);
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
