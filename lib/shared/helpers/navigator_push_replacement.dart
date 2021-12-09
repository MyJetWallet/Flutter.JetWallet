import 'package:flutter/cupertino.dart';

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
