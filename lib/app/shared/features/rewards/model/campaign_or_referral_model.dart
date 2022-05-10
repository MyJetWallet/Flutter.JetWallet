import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/signal_r/model/campaign_response_model.dart';
import 'package:simple_networking/services/signal_r/model/referral_stats_response_model.dart';

part 'campaign_or_referral_model.freezed.dart';
part 'campaign_or_referral_model.g.dart';

// Can be only one type, not two at the same time
@freezed
class CampaignOrReferralModel with _$CampaignOrReferralModel {
  const factory CampaignOrReferralModel({
    CampaignModel? campaign,
    ReferralStatsModel? referralState,
  }) = _CampaignOrReferralModel;

  factory CampaignOrReferralModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignOrReferralModelFromJson(json);
}

@freezed
class CampaignModel with _$CampaignModel {
  const factory CampaignModel({
    List<CampaignConditionModel>? conditions,
    String? imageUrl,
    @Default(false) bool showReferrerStats,
    @JsonKey(name: 'expirationTime') required String timeToComplete,
    required int weight,
    required String title,
    required String description,
    required String campaignId,
    required String deepLink,
  }) = _CampaignModel;

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);
}
