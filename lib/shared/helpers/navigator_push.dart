import 'package:flutter/material.dart';

void navigatorPush(BuildContext context, Widget page, [void Function()? then]) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  ).then((value) {
    if (then != null) {
      then();
    }
  });
}
