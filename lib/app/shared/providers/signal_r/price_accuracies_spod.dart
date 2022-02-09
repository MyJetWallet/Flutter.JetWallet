import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/price_accuracies.dart';
import '../../../../shared/providers/service_providers.dart';

final priceAccuraciesSpod = StreamProvider.autoDispose<PriceAccuracies>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.priceAccuracies();
});
