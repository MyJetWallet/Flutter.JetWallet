import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/server_time_model.dart';
import '../../../../shared/providers/service_providers.dart';

final serverTimeSpod = StreamProvider.autoDispose<ServerTimeModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.serverTime();
});
