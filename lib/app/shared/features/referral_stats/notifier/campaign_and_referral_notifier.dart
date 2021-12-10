import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../../shared/logging/levels.dart';

class CampaignAndReferralStatsNotifier
    extends StateNotifier<CampaignAndReferralStatsModel> {
  CampaignAndReferralStatsNotifier({
    required this.read,
    required this.campaignAndReferralStats,
  }) : super(
    const CampaignAndReferralStatsModel(
      campaigns: <CampaignModel>[],
      referralStats: <ReferralStatsModel>[],
    ),
  ) {
    update(campaignAndReferralStats);
  }

  final CampaignAndReferralStatsModel campaignAndReferralStats;
  final Reader read;

  static final _logger = Logger('ReferrerStatsNotifier');

  Future<void> update(
      CampaignAndReferralStatsModel campaignAndReferralStats,
      ) async {
    _logger.log(notifier, 'updateReferrerStats');

    state = campaignAndReferralStats;
  }
}
