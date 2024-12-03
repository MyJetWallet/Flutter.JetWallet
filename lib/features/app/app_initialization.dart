import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/push_notification_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
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

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCc-F7HOf8dTbB7mMHm6UeSCcOybmvNq8Y',
        authDomain: 'jetwallet-uat.firebaseapp.com',
        projectId: 'jetwallet-uat',
        storageBucket: 'jetwallet-uat.firebasestorage.app',
        messagingSenderId: '709845370864',
        appId: '1:709845370864:web:9059ad52740d1acc81ff35',
        measurementId: 'G-WTLQKCK1F9',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  if (!kIsWeb) {
    await PushNotificationService().initialize(); // doesn't work on web
  }

  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  await getIt.get<AppStore>().initLocale();

  Logger.root.level = Level.ALL;
}
