import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../../shared/logging/levels.dart';

class ReferralStatsNotifier extends StateNotifier<List<ReferralStatsModel>> {
  ReferralStatsNotifier({
    required this.read,
    required this.referralStats,
  }) : super(<ReferralStatsModel>[]) {
    updateReferralStats(referralStats);
  }

  final Reader read;
  final List<ReferralStatsModel> referralStats;

  static final _logger = Logger('ReferrerStatsNotifier');

  Future<void> updateReferralStats(
    List<ReferralStatsModel> referrerStats,
  ) async {
    _logger.log(notifier, 'updateReferrerStats');

    state = referralStats;
  }
}
