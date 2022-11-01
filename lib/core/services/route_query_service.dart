import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/router/app_router.dart';

class RouteQueryService {
  final List<PageRouteInfo<dynamic>> query = [];

  void addToQuery(PageRouteInfo<dynamic> route) {
    query.add(route);
  }

  void removeFromQuery(PageRouteInfo<dynamic> route) {
    query.remove(route);
  }

  void runQuery() {
    for (var i = 0; i < query.length; i++) {
      sRouter.push(
        query[i],
      );

      removeFromQuery(query[i]);
    }
  }
}
