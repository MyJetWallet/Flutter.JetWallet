import 'package:freezed_annotation/freezed_annotation.dart';
import 'campaign_condition_model.dart';

part 'campaign_model.freezed.dart';
part 'campaign_model.g.dart';

@freezed
class CampaignModel with _$CampaignModel {
  const factory CampaignModel({
    required String title,
    required String description,
    @JsonKey(name: 'expirationTime') required String timeToComplete,
    List<CampaignConditionModel>? conditions,
    String? imageUrl,
    required String campaignId,
    required String deepLink,
  }) = _CampaignModel;

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);
}
