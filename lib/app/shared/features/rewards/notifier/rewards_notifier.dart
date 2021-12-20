import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../model/combined_reward_model.dart';

class RewardsNotifier extends StateNotifier<List<CombinedRewardModel>> {
  RewardsNotifier({
    required this.read,
    required this.rewards,
  }) : super(
    <CombinedRewardModel>[],
  ) {
    final sortedRewards = sortRewardsByWeight(rewards);
    updateRewards(sortedRewards);
  }

  final RewardsModel rewards;
  final Reader read;

  static final _logger = Logger('RewardsNotifier');

  Future<void> updateRewards(
      List<CombinedRewardModel> rewards,
      ) async {
    _logger.log(notifier, 'updateRewards');

    state = rewards;
  }

  List<CombinedRewardModel> sortRewardsByWeight(RewardsModel rewards) {
    final sortedRewards = <CombinedRewardModel>[];

    for (final campaign in rewards.campaigns) {
      sortedRewards.add(
        CombinedRewardModel(
          conditions: campaign.conditions,
          timeToComplete: campaign.timeToComplete,
          description: campaign.description,
          title: campaign.title,
          imageUrl: campaign.imageUrl,
          showReferrerStats: campaign.showReferrerStats,
          weight: campaign.weight,
          campaignId: campaign.campaignId,
          deepLink: campaign.deepLink,
        ),
      );
    }

    for (final referralStat in rewards.referralStats) {
      sortedRewards.add(
        CombinedRewardModel(
          weight: referralStat.weight,
          referralInvited: referralStat.referralInvited,
          referralActivated:referralStat.referralActivated,
          bonusEarned:referralStat.bonusEarned,
          commissionEarned:referralStat.commissionEarned,
          total: referralStat.total,
        ),
      );
    }

    sortedRewards.sort((a, b) {
      return b.weight!.compareTo(a.weight!);
    });
    return sortedRewards;
  }
}
