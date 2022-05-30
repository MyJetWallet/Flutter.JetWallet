import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/period_prices_model.dart';

import '../../../../shared/providers/service_providers.dart';

final periodPricesSpod = StreamProvider.autoDispose<PeriodPricesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.periodPrices();
});
