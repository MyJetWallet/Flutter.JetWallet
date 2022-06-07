import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/referral_stats_response_model.dart';

import 'referral_stats_spod.dart';

final referralStatsPod = Provider.autoDispose<List<ReferralStatsModel>>((ref) {
  final referralStats = ref.watch(referralStatsSpod);
  final items = <ReferralStatsModel>[];

  referralStats.whenData((value) {
    for (final referralStats in value.referralStats) {
      items.add(referralStats);
    }
  });

  return items;
});
