import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/prices_model.dart';
import '../../../../service_providers.dart';

final pricesSpod = StreamProvider.autoDispose<PricesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.prices();
});
