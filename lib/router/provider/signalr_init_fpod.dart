import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../shared/providers/service_providers.dart';
import 'authorized_stpod/authorized_stpod.dart';
import 'authorized_stpod/authorized_union.dart';
import 'router_stpod/router_stpod.dart';

final signalRInitFpod = FutureProvider<void>((ref) async {
  final _logger = Logger('signalRInitFpod');

  /// Watching for authentication changes
  ref.watch(routerStpod);
  final authorized = ref.watch(authorizedStpod);
  final signalRService = ref.watch(signalRServicePod);

  if (authorized.state == const Home()) {
    try {
      await signalRService.init();
    } catch (e) {
      _logger.warning('Failed to make SignalR init on the first launch', e);
    }
  }
});
