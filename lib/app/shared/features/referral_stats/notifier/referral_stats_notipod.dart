import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../provider/referral_stats_pod.dart';
import 'referral_stats_notifier.dart';

final referralStatsNotipod = StateNotifierProvider.autoDispose<
    ReferralStatsNotifier, List<ReferralStatsModel>>(
  (ref) {
    final referralStats = ref.watch(referralStatsPod);

    return ReferralStatsNotifier(
      read: ref.read,
      referralStats: referralStats,
    );
  },
);
