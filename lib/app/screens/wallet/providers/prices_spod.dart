import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/prices_model.dart';
import '../../../../service_providers.dart';

final pricesSpod = StreamProvider<PricesModel>((ref) {
  final signalRService = ref.watch(signalRServicePod);

  return signalRService.prices();
});
