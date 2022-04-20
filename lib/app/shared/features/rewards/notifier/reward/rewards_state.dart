import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/campaign_or_referral_model.dart';

part 'rewards_state.freezed.dart';
part 'rewards_state.g.dart';

@freezed
class RewardsState with _$RewardsState {
  const factory RewardsState({
    required List<CampaignOrReferralModel> sortedCampaigns,
  }) = _RewardsState;

  factory RewardsState.fromJson(Map<String, dynamic> json) =>
      _$RewardsStateFromJson(json);
}
