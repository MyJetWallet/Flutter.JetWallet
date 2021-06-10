import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/services/signal_r/service/helpers/signal_r_log.dart';
import '../../service_providers.dart';
import 'router_stpod.dart';
import 'union/router_union.dart';

final routerInitFpod = FutureProvider<void>((ref) async {
  final router = ref.watch(routerStpod);
  final signalRService = ref.watch(signalRServicePod);

  if (router.state == const Authorised()) {
    try {
      await signalRService.init();
    } catch (e) {
      signalRLog('Failed to make init on first launch. $e');
    }
  }
});
