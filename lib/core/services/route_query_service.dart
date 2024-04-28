import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/router/app_router.dart';

enum RouteQueryAction { push, navigate, replace }

class RouteQueryModel {
  RouteQueryModel({
    this.query,
    this.action,
    this.func,
  });

  final PageRouteInfo<dynamic>? query;
  final RouteQueryAction? action;
  final Function()? func;
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

    for (final i = 0; i < query.length;) {
      if (query[i].action != null) {
        switch (query[i].action) {
          case RouteQueryAction.push:
            sRouter.push(
              query[i].query!,
            );
          case RouteQueryAction.navigate:
            sRouter.navigate(
              query[i].query!,
            );
          case RouteQueryAction.replace:
            sRouter.replaceAll([
              query[i].query!,
            ]);
          default:
        }
      }

      if (query[i].func != null) {
        query[i].func?.call();
      }

      removeFromQuery(query[i]);
    }
    isNavigate = false;
  }
}
