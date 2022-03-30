import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'core/app/app.dart';
import 'core/app/app_builder.dart';
import 'core/app/app_initialization.dart';
import 'shared/logging/debug_logging.dart';

Future<void> main() async {
  await appInitialization();

  Logger.root.onRecord.listen((record) => debugLogging(record));

  runApp(
    MaterialApp(
      restorationScopeId: 'app',
      home: DevicePreview(
        enabled: false,
        builder: (context) {
          return App(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              child = DevicePreview.appBuilder(context, child);
              child = AppBuilder(child);
              return child;
            },
            locale: DevicePreview.locale(context),
          );
        },
      ),
    ),
  );
}
