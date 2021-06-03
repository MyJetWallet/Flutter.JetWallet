import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/instruments_model.dart';
import '../../../../service_providers.dart';

final instrumentsSpod = StreamProvider<InstrumentsModel>((ref) {
  final signalRService = ref.watch(signalRServicePod);

  return signalRService.instruments();
});
