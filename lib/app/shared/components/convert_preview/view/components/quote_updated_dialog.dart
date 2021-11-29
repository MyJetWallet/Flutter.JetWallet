import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showQuoteUpdatedDialog({
  required BuildContext context,
  required Function() onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return CupertinoAlertDialog(
        title: const Text(
          'Alert',
        ),
        content: const Text(
          'Quote has been updated',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onPressed();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text(
              'Got it!',
            ),
          )
        ],
      );
    },
  );
}
