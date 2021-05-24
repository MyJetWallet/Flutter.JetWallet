import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/providers/auth_model_notipod.dart';
import '../../service_providers.dart';
import 'router_stpod.dart';
import 'union/router_union.dart';

final routerInitFpod = FutureProvider<void>((ref) async {
  final router = ref.watch(routerStpod);
  final signalRService = ref.watch(signalRServicePod);
  final authModel = ref.watch(authModelNotipod);

  if (router.state == const Unauthorised()) {
    // todo dispose signalR
  } else {
    await signalRService.init(authModel.token);
  }
});
