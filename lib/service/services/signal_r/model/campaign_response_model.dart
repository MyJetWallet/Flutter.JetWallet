import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_response_model.freezed.dart';
part 'campaign_response_model.g.dart';

@freezed
class CampaignResponseModel with _$CampaignResponseModel {
  const factory CampaignResponseModel({
    required List<CampaignModel> campaigns,
  }) = _CampaignResponseModel;

  factory CampaignResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignResponseModelFromJson(json);
}

@freezed
class CampaignModel with _$CampaignModel {
  const factory CampaignModel({
    List<CampaignConditionModel>? conditions,
    String? imageUrl,
    @JsonKey(name: 'expirationTime') required String timeToComplete,
    @Default(false) bool showReferrerStats,
    required int weight,
    required String title,
    required String description,
    required String campaignId,
    required String deepLink,
  }) = _CampaignModel;

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);
}

@freezed
class CampaignConditionModel with _$CampaignConditionModel {
  const factory CampaignConditionModel({
    @JsonKey(name: 'params') CampaignConditionParametersModel? parameters,
    RewardModel? reward,
    required int type,
  }) = _CampaignConditionModel;

  factory CampaignConditionModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignConditionModelFromJson(json);
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
      ) => _$CampaignConditionParametersModelFromJson(json);
}

@freezed
class RewardModel with _$RewardModel {
  const factory RewardModel({
    String? asset,
    required double amount,
  }) = _RewardModel;

  factory RewardModel.fromJson(Map<String, dynamic> json) =>
      _$RewardModelFromJson(json);
}
