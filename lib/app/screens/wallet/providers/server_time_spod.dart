import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/service/model/wallet/server_time_model.dart';
import '../../../../service_providers.dart';

final serverTimeSpod = StreamProvider<ServerTimeModel>((ref) {
  final signalRService = ref.watch(signalRServicePod);

  return signalRService.serverTime();
});
