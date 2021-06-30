import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/helpers/show_plain_snackbar.dart';
import 'auth_button_grey.dart';

class OpenMyEmailButton extends StatelessWidget {
  const OpenMyEmailButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthButtonGrey(
      text: 'Open My Email',
      onTap: () {
        if (Platform.isAndroid) {
          const intent = AndroidIntent(
            action: 'android.intent.action.MAIN',
            category: 'android.intent.category.APP_EMAIL',
            // open email inside a new window instead of the app
            flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          );

          try {
            intent.launch();
          } catch (e) {
            showPlainSnackbar(context, '$e');
          }
        } else if (Platform.isIOS) {
          try {
            launch('message://');
          } catch (e) {
            showPlainSnackbar(context, '$e');
          }
        }
      },
    );
  }
}
