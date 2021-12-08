import 'package:freezed_annotation/freezed_annotation.dart';
import 'campaign_condition_model.dart';

part 'campaign_model.freezed.dart';
part 'campaign_model.g.dart';

@freezed
class CampaignModel with _$CampaignModel {
  const factory CampaignModel({
    List<CampaignConditionModel>? conditions,
    String? imageUrl,
    @JsonKey(name: 'expirationTime') required String timeToComplete,
    required String title,
    required String description,
    required String campaignId,
    required String deepLink,
  }) = _CampaignModel;

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);
}
