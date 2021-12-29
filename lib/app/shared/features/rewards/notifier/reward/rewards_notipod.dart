import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../../screens/market/provider/market_campaigns_pod.dart';
import '../../../referral_stats/provider/referral_stats_pod.dart';
import '../../model/campaign_or_referral_model.dart';

final rewardsNotipod = Provider.autoDispose<List<CampaignOrReferralModel>>(
  (ref) {
    final referralStats = ref.watch(referralStatsPod);
    final campaigns = ref.watch(marketCampaignsPod);

    return _sort(campaigns, referralStats);
  },
  name: 'rewardsNotipod',
);

List<CampaignOrReferralModel> _sort(
  List<CampaignModel> campaigns,
  List<ReferralStatsModel> referralStats,
) {
  final combinedArray = <CampaignOrReferralModel>[];
  final campaignsArray = List<CampaignModel>.from(campaigns);
  final referralStatsArray =
      List<ReferralStatsModel>.from(referralStats);

  for (final campaign in campaignsArray) {
    combinedArray.add(CampaignOrReferralModel(campaign: campaign));
  }

  for (final referralStat in referralStatsArray) {
    combinedArray.add(CampaignOrReferralModel(referralState: referralStat));
  }

  combinedArray.sort((a, b) {
    final weight1 = a.campaign?.weight ?? a.referralState!.weight;
    final weight2 = b.campaign?.weight ?? b.referralState!.weight;

    return weight1.compareTo(weight2);
  });

  return combinedArray;
}
