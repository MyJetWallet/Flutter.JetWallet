import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/push_notification_service.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

Future<void> appInitialization(String environment) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Make android status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  await PushNotificationService().initialize(); // doesn't work on web

  /// register all dependecy injection
  await getItInit(env: environment);

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  Logger.root.level = Level.ALL;
}
