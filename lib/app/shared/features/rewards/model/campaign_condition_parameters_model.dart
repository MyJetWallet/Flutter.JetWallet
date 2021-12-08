import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_condition_parameters_model.freezed.dart';

part 'campaign_condition_parameters_model.g.dart';

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
