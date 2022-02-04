import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/convert_price_accuracies.dart';
import '../../../../shared/providers/service_providers.dart';

final convertPriceAccuraciesSpod =
    StreamProvider.autoDispose<ConvertPriceAccuracies>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.convertPriceAccuracies();
});
