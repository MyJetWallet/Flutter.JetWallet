import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../shared/providers/service_providers.dart';
import '../notifier/startup_notifier/authorized_union.dart';
import '../notifier/startup_notifier/startup_notipod.dart';
import 'router_stpod/router_stpod.dart';

final signalRInitFpod = FutureProvider<void>((ref) async {
  final _logger = Logger('signalRInitFpod');

  /// Watching for authentication changes to reset user's assets after logout
  ref.watch(routerStpod);
  final startup = ref.watch(startupNotipod);
  final signalRService = ref.watch(signalRServicePod);

  if (startup.authorized is Home) {
    try {
      await signalRService.init();
    } catch (e) {
      _logger.warning('Failed to make SignalR init on the first launch', e);
    }
  }
});
