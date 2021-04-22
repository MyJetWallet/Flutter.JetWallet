import 'dart:io';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:jetwallet/main_app.dart';
import 'package:jetwallet/state/config/actions.dart';
import 'package:jetwallet/state/config/config_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configStorage = ConfigStorage();
  Injector.appInstance.registerDependency<ConfigStorage>(() => configStorage);

  // #730 Don't delete the line bellow. Platform.localeName requires some delay on iOS
  // to get localization string. Otherwise it's null
  await Future<dynamic>.delayed(const Duration(seconds: 1));
  final locale = Platform.localeName.split('').take(2).join().toString();
  await initLocale(configStorage, locale);

  // Crashlytics.instance.enableInDevMode = true;
  // Crashlytics.instance.log('test log');
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;

  final store = buildStore();

  runApp(
    MainApp(
      store: store,
    ),
  );
}
