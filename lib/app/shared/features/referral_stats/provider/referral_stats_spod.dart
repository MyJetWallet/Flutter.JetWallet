import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/referral_stats_response_model.dart';

import '../../../../../shared/providers/service_providers.dart';

final referralStatsSpod =
    StreamProvider.autoDispose<ReferralStatsResponseModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.referralStats();
});
