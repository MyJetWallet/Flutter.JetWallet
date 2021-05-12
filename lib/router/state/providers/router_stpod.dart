import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../union/router_union.dart';

final routerStpod = StateProvider<RouterUnion>((ref) {
  return const RouterUnion.unauthorised();
});
