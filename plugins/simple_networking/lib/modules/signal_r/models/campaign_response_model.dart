import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'campaign_response_model.freezed.dart';
part 'campaign_response_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class CampaignResponseModel with _$CampaignResponseModel {
  const factory CampaignResponseModel({
    required List<CampaignModel> campaigns,
  }) = _CampaignResponseModel;

  factory CampaignResponseModel.fromJson(Map<String, dynamic> json) => _$CampaignResponseModelFromJson(json);
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
