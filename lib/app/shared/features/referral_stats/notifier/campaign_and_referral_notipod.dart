import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../screens/market/provider/market_campaigns_pod.dart';
import '../provider/referral_stats_pod.dart';
import 'campaign_and_referral_notifier.dart';

final campaignAndReferralNotipod = StateNotifierProvider.autoDispose<
    CampaignAndReferralStatsNotifier, CampaignAndReferralStatsModel>(
      (ref) {
    final referralStats = ref.watch(referralStatsPod);
    final campaigns = ref.watch(marketCampaignsPod);

    final campaignAndReferralStats = CampaignAndReferralStatsModel(
      referralStats: referralStats,
      campaigns: campaigns,
    );

    return CampaignAndReferralStatsNotifier(
      read: ref.read,
      campaignAndReferralStats: campaignAndReferralStats,
    );
  },
);
