import 'package:flutter/material.dart';

/// Navigates to the first route aka [initialRoute] aka [Router()]
void navigateToRouter(GlobalKey<NavigatorState> navigatorKey) {
  navigatorKey.currentState!.popUntil(
    (route) => route.isFirst == true,
  );
}
