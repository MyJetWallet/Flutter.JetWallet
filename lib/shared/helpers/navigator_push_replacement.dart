import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void navigatorPushReplacement(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}
