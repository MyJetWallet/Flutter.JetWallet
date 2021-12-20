import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../screens/market/provider/market_campaigns_pod.dart';
import '../../referral_stats/provider/referral_stats_pod.dart';
import '../model/combined_reward_model.dart';
import 'rewards_notifier.dart';

final rewardsNotipod = StateNotifierProvider.autoDispose<RewardsNotifier,
    List<CombinedRewardModel>>((ref) {
  final referralStats = ref.watch(referralStatsPod);
  final campaigns = ref.watch(marketCampaignsPod);

  final rewards = RewardsModel(
    referralStats: referralStats,
    campaigns: campaigns,
  );

  return RewardsNotifier(
    read: ref.read,
    rewards: rewards,
  );
});
