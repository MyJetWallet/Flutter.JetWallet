import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
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

    var result = await OpenMailApp.openMailApp();

    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);

      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    } else if (!result.didOpen && result.canOpen) {
      await showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
          );
        },
      );
    }



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
        title: Text("Open Mail App"),
        content: Text("No mail apps installed"),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}