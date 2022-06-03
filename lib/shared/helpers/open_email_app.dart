import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'show_plain_snackbar.dart';

Future<void> openEmailApp(BuildContext context) async {
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


void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Open Mail App'),
        content: const Text('No mail apps installed'),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
