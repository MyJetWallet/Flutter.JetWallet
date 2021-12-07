import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_request_model.freezed.dart';
part 'campaign_request_model.g.dart';

@freezed
class CampaignRequestModel with _$CampaignRequestModel {
  const factory CampaignRequestModel({
    required String lang,
  }) = _CampaignRequestModel;

  factory CampaignRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignRequestModelFromJson(json);
}
