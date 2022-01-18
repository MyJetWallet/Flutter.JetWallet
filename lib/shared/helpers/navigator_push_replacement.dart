import 'package:flutter/cupertino.dart';

void navigatorPushReplacement(
  BuildContext context,
  Widget page, [
  void Function()? then,
]) {
  Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
      builder: (context) {
        return page;
      },
    ),
  ).then((value) {
    then?.call();
  });
}
