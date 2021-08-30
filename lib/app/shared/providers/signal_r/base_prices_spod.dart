import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/base_prices_model.dart';
import '../../../../shared/providers/service_providers.dart';

final basePricesSpod = StreamProvider.autoDispose<BasePricesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.basePrices();
});
