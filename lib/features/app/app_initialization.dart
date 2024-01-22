import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
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
      statusBarBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// register all dependecy injection
  await getItInit(env: environment);

  await Firebase.initializeApp();
  await PushNotificationService().initialize(); // doesn't work on web

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  const appId = String.fromEnvironment('INTERCOM_APP_ID');
  const androidKey = String.fromEnvironment('INTERCOM_ANDROID_KEY');
  const iOSKey = String.fromEnvironment('INTERCOM_IOS_KEY');

  await Intercom.instance.initialize(appId, iosApiKey: iOSKey, androidApiKey: androidKey);

  Logger.root.level = Level.ALL;
}
