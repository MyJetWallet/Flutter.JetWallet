import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

import '../../shared/services/push_notification_service.dart';

Future<void> appInitialization() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make android status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  await PushNotificationService().initialize(); // doesn't work on web

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  Logger.root.level = Level.ALL;
}
