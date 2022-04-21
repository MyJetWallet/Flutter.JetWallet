import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/campaign_or_referral_model.dart';
import 'rewards_state.dart';

class RewardsNotifier extends StateNotifier<RewardsState> {
  RewardsNotifier({
    required this.read,
    required this.sortedCampaigns,
  }) : super(
          const RewardsState(
            sortedCampaigns: <CampaignOrReferralModel>[],
          ),
        ) {
    state = state.copyWith(
      sortedCampaigns: sortedCampaigns,
    );
  }

  final Reader read;
  final List<CampaignOrReferralModel> sortedCampaigns;

}
