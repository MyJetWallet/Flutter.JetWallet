import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/router/app_router.dart';

enum RouteQueryAction { push, navigate, replace }

class RouteQueryModel {
  RouteQueryModel({
    required this.query,
    required this.action,
  });

  final PageRouteInfo<dynamic> query;
  final RouteQueryAction action;
}

class RouteQueryService {
  final List<RouteQueryModel> query = [];

  bool isNavigate = false;

  void addToQuery(RouteQueryModel route) {
    query.add(route);
  }

  void removeFromQuery(RouteQueryModel route) {
    query.remove(route);
  }

  void runQuery() {
    isNavigate = true;

    for (var i = 0; i < query.length; i++) {
      switch (query[i].action) {
        case RouteQueryAction.push:
          sRouter.push(
            query[i].query,
          );
          break;
        case RouteQueryAction.navigate:
          sRouter.navigate(
            query[i].query,
          );
          break;
        case RouteQueryAction.replace:
          sRouter.replaceAll([
            query[i].query,
          ]);
          break;
        default:
      }

      removeFromQuery(query[i]);
    }
  }
}
