import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/signal_r/model/campaign_response_model.dart';
import 'package:simple_networking/services/signal_r/model/referral_stats_response_model.dart';

part 'campaign_or_referral_model.freezed.dart';
part 'campaign_or_referral_model.g.dart';

// Can be only one type, not two at the same time
@freezed
class CampaignOrReferralModel with _$CampaignOrReferralModel {
  const factory CampaignOrReferralModel({
    @JsonSerializable(explicitToJson: true) CampaignModel? campaign,
    ReferralStatsModel? referralState,
  }) = _CampaignOrReferralModel;

  factory CampaignOrReferralModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignOrReferralModelFromJson(json);
}
