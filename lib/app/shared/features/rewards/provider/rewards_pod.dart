import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../screens/market/provider/market_campaigns_pod.dart';
import '../../referral_stats/provider/referral_stats_pod.dart';
import '../model/campaign_or_referral_model.dart';

final rewardsNotipod = Provider.autoDispose<List<CampaignOrReferralModel>>(
  (ref) {
    final referralStats = ref.watch(referralStatsPod);
    final campaigns = ref.watch(marketCampaignsPod);

    final rewards = RewardsModel(
      referralStats: referralStats,
      campaigns: campaigns,
    );

    return _sorting(rewards);
  },
  name: 'rewardsNotipod',
);

List<CampaignOrReferralModel> _sorting(RewardsModel rewards) {
  final combinedArray = <CampaignOrReferralModel>[];
  final campaignsArray = List<CampaignModel>.from(rewards.campaigns);
  final referralStatsArray =
      List<ReferralStatsModel>.from(rewards.referralStats);

  for (final campaign in campaignsArray) {
    combinedArray.add(CampaignOrReferralModel(campaign: campaign));
  }

  for (final referralStat in referralStatsArray) {
    combinedArray.add(CampaignOrReferralModel(referralStat: referralStat));
  }

  combinedArray.sort((a, b) {
    final weight1 = a.campaign?.weight ?? a.referralStat!.weight;
    final weight2 = b.campaign?.weight ?? b.referralStat!.weight;

    return weight1.compareTo(weight2);
  });

  return combinedArray;
}
