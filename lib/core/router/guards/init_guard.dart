import 'dart:async';

import 'package:auto_route/auto_route.dart';

class InitGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    resolver.next();
  }
}
