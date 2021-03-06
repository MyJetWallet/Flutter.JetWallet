import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/instruments_model.dart';
import '../../../../shared/providers/service_providers.dart';

final instrumentsSpod = StreamProvider.autoDispose<InstrumentsModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.instruments();
});
