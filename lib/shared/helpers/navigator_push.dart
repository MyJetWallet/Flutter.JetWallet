import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
