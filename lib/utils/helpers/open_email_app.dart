import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

import 'list_of_mail_apps.dart';
import 'show_plain_snackbar.dart';

Future<void> openEmailApp(BuildContext context) async {
  Future<void> defaultFunction() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.APP_EMAIL',
        // open email inside a new window instead of the app
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );

      try {
        await intent.launch();
      } catch (e) {
        showPlainSnackbar(context, '$e');
      }
    } else if (Platform.isIOS) {
      try {
        await launchUrl(Uri.parse('message://'));
      } catch (e) {
        showPlainSnackbar(context, '$e');
      }
    }
  }

  // Android: Will open mail app or show native picker.
  // iOS: Will open mail app if single mail app found.
  final result = await OpenMailApp.openMailApp();

  // If no mail apps found, show only one method
  if (!result.didOpen && !result.canOpen) {
    showMailAppsOptions(
      context,
      [],
      defaultFunction,
    );

    // iOS: if multiple mail apps found, show dialog to select.
    // There is no native intent/default app system in iOS so
    // you have to do it yourself.
  } else if (!result.didOpen && result.canOpen) {
    showMailAppsOptions(
      context,
      result.options,
      defaultFunction,
    );
  }
}
