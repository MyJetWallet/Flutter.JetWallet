import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/push_notification_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/firebase_options.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

Future<void> appInitialization(String environment) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationService().initialize(); // doesn't work on web

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  await getIt.get<AppStore>().initLocale();

  Logger.root.level = Level.ALL;
}
