import 'package:flutter/cupertino.dart';

void navigatorPush(BuildContext context, Widget page, [void Function()? then]) {
  Navigator.push(
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
