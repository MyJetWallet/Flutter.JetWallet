import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/di.dart';
import '../../core/services/local_storage_service.dart';
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

  final result = await OpenMailApp.getMailApps();

  final storageService = getIt.get<LocalStorageService>();
  final lastMail = await storageService.getValue(lastUsedMail);
  if (lastMail != null) {
    final lastResult =
        result.where((element) => element.name == lastMail).toList();
    if (lastResult.isNotEmpty) {
      await OpenMailApp.openSpecificMailApp(lastResult[0]);

      return;
    }
  }
  if (context.mounted) {
    showMailAppsOptions(
      context,
      result,
      defaultFunction,
    );
  }
}
