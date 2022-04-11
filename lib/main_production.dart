import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

import 'core/app/app.dart';
import 'core/app/app_initialization.dart';

Future<void> main() async {
  await appInitialization();

  runZonedGuarded(() => runApp(const App()), (error, stackTrace) {
    Logger.root.log(Level.SEVERE, 'ZonedGuarded', error, stackTrace);
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
