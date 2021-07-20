import 'package:flutter/material.dart';

void navigatorPushReplacement(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}
