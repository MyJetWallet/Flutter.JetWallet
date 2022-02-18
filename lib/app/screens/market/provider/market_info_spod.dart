import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/market_info_model.dart';
import '../../../../shared/providers/service_providers.dart';

final marketInfoSpod =
    StreamProvider.autoDispose<TotalMarketInfoModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.marketInfo();
});
