import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../service_providers.dart';
import 'router_stpod/router_stpod.dart';
import 'router_stpod/router_union.dart';

final routerInitFpod = FutureProvider<void>((ref) async {
  final _logger = Logger('routerInitFpod');

  final router = ref.watch(routerStpod);
  final signalRService = ref.watch(signalRServicePod);

  if (router.state == const Authorised()) {
    try {
      await signalRService.init();
    } catch (e) {
      _logger.warning('Failed to make SignalR init on the first launch', e);
    }
  }
});
