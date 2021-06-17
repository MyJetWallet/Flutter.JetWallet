import 'package:flutter/material.dart';

void navigatorPush(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}

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
