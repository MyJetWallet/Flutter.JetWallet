import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../service_providers.dart';
import 'authorized_stpod/authorized_stpod.dart';
import 'authorized_stpod/authorized_union.dart';

final signalRInitFpod = FutureProvider<void>((ref) async {
  final _logger = Logger('signalRInitFpod');

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
