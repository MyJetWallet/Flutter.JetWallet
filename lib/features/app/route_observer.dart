import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';

class SimpleRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    getIt.get<SimpleLoggerService>().logger.d(
      '''SimpleRouteObserver - push to: ${route.settings.name} from: ${previousRoute?.settings.name}''',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    getIt.get<SimpleLoggerService>().logger.d(
          'SimpleRouteObserver - didPop: ${route.settings.name}',
        );
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    getIt.get<SimpleLoggerService>().logger.d(
          'SimpleRouteObserver - Tab route visited: ${route.name}',
        );
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    getIt.get<SimpleLoggerService>().logger.d(
          'SimpleRouteObserver - Tab route re-visited: ${route.name}',
        );
  }
}
