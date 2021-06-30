import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'router_union.dart';

final routerStpod = StateProvider<RouterUnion>((ref) {
  return const RouterUnion.unauthorized();
});
