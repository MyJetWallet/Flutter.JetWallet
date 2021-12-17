import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../../shared/logging/levels.dart';

class CampaignAndReferralStatsNotifier
    extends StateNotifier<CampaignAndReferralStatsModel> {
  CampaignAndReferralStatsNotifier({
    required this.read,
    required this.campaignAndReferralStats,
  }) : super(
    const CampaignAndReferralStatsModel(
      campaigns: [],
      referralStats: [],
    ),
  ) {
    updateCampaignAndReferralStats(campaignAndReferralStats);
  }

  final CampaignAndReferralStatsModel campaignAndReferralStats;
  final Reader read;

  static final _logger = Logger('CampaignAndReferralStatsModel');

  Future<void> updateCampaignAndReferralStats(
      CampaignAndReferralStatsModel campaignAndReferralStats,
      ) async {
    _logger.log(notifier, 'updateCampaignAndReferralStats');

    state = campaignAndReferralStats;
  }
}
