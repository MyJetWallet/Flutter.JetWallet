import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';

enum RouteQueryAction { push, navigate, replace }

class RouteQueryModel {
  RouteQueryModel({
    required this.query,
    required this.action,
    this.func,
  });

  final PageRouteInfo<dynamic> query;
  final RouteQueryAction action;
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

      if (query[i].func != null) {
        query[i].func!();
      }

      removeFromQuery(query[i]);
    }
  }
}
