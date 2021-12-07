import 'package:freezed_annotation/freezed_annotation.dart';
import 'campaign_model.dart';

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
