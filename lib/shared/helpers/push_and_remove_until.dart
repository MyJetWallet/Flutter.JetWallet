import 'package:flutter/material.dart';

void pushAndRemoveUntil({
  required GlobalKey<NavigatorState> navigatorKey,
  required Widget page,
}) {
  navigatorKey.currentState!.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
    (route) => route.isFirst == true,
  );
}
