import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'campaign_or_referral_model.freezed.dart';
part 'campaign_or_referral_model.g.dart';

// Can be only one type, not two at the same time
@freezed
class CampaignOrReferralModel with _$CampaignOrReferralModel {
  const factory CampaignOrReferralModel({
    CampaignModel? campaign,
    ReferralStatsModel? referralState,
  }) = _CampaignOrReferralModel;

  factory CampaignOrReferralModel.fromJson(Map<String, dynamic> json) => _$CampaignOrReferralModelFromJson(json);
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

  factory CampaignModel.fromJson(Map<String, dynamic> json) => _$CampaignModelFromJson(json);
}

@freezed
class ReferralStatsModel with _$ReferralStatsModel {
  const factory ReferralStatsModel({
    required int weight,
    required int referralInvited,
    required int referralActivated,
    required String descriptionLink,
    @DecimalSerialiser() required Decimal bonusEarned,
    @DecimalSerialiser() required Decimal commissionEarned,
    @DecimalSerialiser() required Decimal total,
  }) = _ReferralStatsModel;

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) => _$ReferralStatsModelFromJson(json);
}

@freezed
class CampaignConditionModel with _$CampaignConditionModel {
  const factory CampaignConditionModel({
    @JsonKey(name: 'params') CampaignConditionParametersModel? parameters,
    RewardModel? reward,
    required String deepLink,
    required int type,
    required String description,
  }) = _CampaignConditionModel;

  factory CampaignConditionModel.fromJson(Map<String, dynamic> json) => _$CampaignConditionModelFromJson(json);
}

@freezed
class CampaignConditionParametersModel with _$CampaignConditionParametersModel {
  const factory CampaignConditionParametersModel({
    @JsonKey(name: 'Passed') String? passed,
    @JsonKey(name: 'Asset') String? asset,
    @JsonKey(name: 'RequiredAmount') String? requiredAmount,
    @JsonKey(name: 'TradedAmount') String? tradedAmount,
  }) = _CampaignConditionParametersModel;

  factory CampaignConditionParametersModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CampaignConditionParametersModelFromJson(json);
}

@freezed
class RewardModel with _$RewardModel {
  const factory RewardModel({
    String? asset,
    @DecimalSerialiser() required Decimal amount,
  }) = _RewardModel;

  factory RewardModel.fromJson(Map<String, dynamic> json) => _$RewardModelFromJson(json);
}
